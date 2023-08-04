using StaticArrays
using BenchmarkTools
using LinearAlgebra

begin ## 请隐藏这个程序块来直接阅读主要程序
    function eye(n, T = Float64)
        f(i,j) = T(i == j)
        return StaticArrays.sacollect(SMatrix{n,n}, f(i,j) for i in 1:n, j in 1:n)
    end

	@inline function TᵢⱼS(θᵢ,i,DH)
		θ = θᵢ + DH[i,1];
		Tᵢⱼ₁=@SMatrix [cos(θ) 	-sin(θ) 	0.0 	0.0;
			 sin(θ) 	cos(θ) 	0.0 	0.0;
			 0.0 			0.0 			1.0 	DH[i,3];
			 0.0 			0.0 			0.0 	1.0];
		Tᵢⱼ₂=@SMatrix [1.0 0.0 				0.0 				DH[i,2];
			  0.0 cos(DH[i,4]) 	-sin(DH[i,4])  	0.0;
			  0.0 sin(DH[i,4]) 	cos(DH[i,4]) 	0.0;
			  0.0 0.0 				0.0 				1.0];
		return Tᵢⱼ₁*Tᵢⱼ₂
        # return @SMatrix [cos(θ) -sin(θ)*cos(DH[i,4]) sin(θ)*sin(DH[i,4]) DH[i,2]*cos(θ);
        #                  sin(θ) cos(θ)*cos(DH[i,4]) -cos(θ)*sin(DH[i,4]) DH[i,2]*sin(θ);
        #                  0.0 sin(DH[i,4]) cos(DH[i,4]) DH[i,3];
        #                  0.0 0.0 0.0 1.0];
	end
		
	function FkineDHS(θ,DH)
		T = eye(4);
		n = size(DH,1)
		@inbounds for i in 1:n
			T = T*TᵢⱼS(θ[i],i,DH)
		end
		return T
	end

    function FkineDHS_all(θ,DH)
        DOF = size(DH,1)
        T = eye(4);
        Ts = [eye(4) for i = 1:DOF]
        @inbounds for i in 1:DOF
            T = T*TᵢⱼS(θ[i],i,DH)
            Ts[i] = T;
        end
        return Ts
    end

    function T2rt(T::T₁) where {T₁}
        if !(T₁<: SMatrix)
            # @warn "T is not an SMatrix, use SMatrix for best performance"
        end
        R = T[SOneTo(3),SOneTo(3)];
        P = T[SOneTo(3),4];
        return R,P
    end

    function wraptoπ(a)
        b = a
        if b>0
            n = floor(a/2π);
            b = a-n*2π
            if b > π
                b = b - 2π
            end
        else
            n = floor(a/(-2π))
            b = a-n*(-2π)
            if b < -π
                b = b+2π
            end
        end
        return b
    end
    
    @inline function wrapto1(a)
        if a > 1
            return 1
        elseif a < -1
            return -1
        else
            return a
        end
    end

    function MatrixLog3(R::T) where {T}
        if !(T<: SMatrix)
            # @warn "R is not an SMatrix, use SMatrix for best performance"
        end
        acosinput = (tr(R) - 1) / 2;
        if acosinput >= 1.0
            so3mat = @SMatrix zeros(3,3);
        elseif acosinput <= -1.0
            if abs(1 + R[3, 3]) > 1e-15
                omg = (1 / sqrt(2 * (1 + R[3, 3])))* @SVector [R[1,3]; R[2,3]; 1 + R[3,3]];
            elseif abs(1 + R[2, 2]) > 1e-15
                omg = (1 / sqrt(2 * (1 + R[2, 2])))* @SVector [R[1, 2]; 1 + R[2, 2]; R[3, 2]];
            else
                omg = (1 / sqrt(2 * (1 + R[1, 1])))* @SVector [1 + R[1, 1]; R[2, 1]; R[3, 1]];
            end
            so3mat = mcross(pi * omg);
        else
            theta = acos(acosinput);
            so3mat = theta * (1 / (2 * sin(theta))) * (R .- R');
        end
        return so3mat
    end

    function MatrixLog6(T::T₁) where {T₁}
        if !(T₁<: SMatrix)
            # @warn "T is not an SMatrix, use SMatrix for best performance"
        end
        R, p = T2rt(T);
        omgmat = MatrixLog3(R);
        if maximum(abs.(omgmat)) < 1e-15
            expmat = vcat(hcat((@SMatrix zeros(3,3)), T[SOneTo(3), 4]), @SMatrix zeros(1,4));
        else
            theta = acos(wrapto1((tr(R) - 1) / 2));
            expmat = vcat(hcat(omgmat, (eye(3) .- omgmat ./ 2 .+ (1 / theta - cot(theta / 2) / 2) .* (omgmat * omgmat) ./ theta) * p), @SMatrix zeros(1,4))
        end
        return expmat
    end

    @inline function se3toVec(se3)
        return @SVector [se3[1,4],se3[2,4],se3[3,4],se3[3,2],se3[1,3],se3[2,1]]
    end
    @inline invT(T) = vcat(hcat((T[SOneTo(3),SOneTo(3)])',-(T[SOneTo(3),SOneTo(3)])'*T[SOneTo(3),4]),@SMatrix [0.0 0.0 0.0 1.0]);
    @inline mcross(x) = @SMatrix [0 -x[3] x[2];x[3] 0 -x[1];-x[2] x[1] 0]
end

begin ## 注意，这个模块中的函数仅能保证计算总量正确而不保证函数结果正确
    function my_jacobe(q,DH)
        DOF = size(DH,1)
        J0 = Vector{SVector{6,Float64}}(undef,DOF)
        Ts = FkineDHS_all(q,DH);
        Rb = Ts[end][SOneTo(3),SOneTo(3)];
        pe = Ts[end][SOneTo(3),4];
        for i = 1:DOF
            zi = Ts[i][SOneTo(3),3];
            pi = Ts[i][SOneTo(3),4];
            J0[i] = [cross(zi,pe-pi); zi]
        end
        J0 = hcat(J0...)
        JB = vcat([Rb' (@SMatrix zeros(3,3))], [(@SMatrix zeros(3,3)) Rb']) * J0;
        return JB
    end

    function my_jacob0(q,DH)
        DOF = size(DH,1)
        J0 = Vector{SVector{6,Float64}}(undef,DOF)
        Ts = FkineDHS_all(q,DH);
        pe = Ts[end][SOneTo(3),4];
        for i = 1:DOF
            zi = Ts[i][SOneTo(3),3];
            pi = Ts[i][SOneTo(3),4];
            J0[i] = [cross(zi,pe-pi); zi]
        end
        J0 = hcat(J0...)
        return J0
    end

    function my_ikine_Newton(Te,DH,q0)
        NMax = 10;
        q = q0;
        T = FkineDHS(q0,DH);
        for i = 1:NMax
            error = MatrixLog6(invT(T)*Te);
            e = se3toVec(error);
            JB = my_jacobe(q,DH);
            dq = JB\e;
            # @show norm(e);
            q = q + dq;
            T = FkineDHS(q,DH);
        end
        return wraptoπ.(q)
    end
end

DHS = @SMatrix [0.0  175.0  495.0    -π/2;
				  -π/2  900.0   0.0     0.0;
				  0.0   170.0   0.0     -π/2;
				  0.0   0.0     960.0   π/2;
				  0.0   0.0     0.0     -π/2;
				  π     0.0     135.0   0.0];

qs = @SVector zeros(6);

T = FkineDHS(qs,DHS);

@btime FkineDHS(qs,$DHS) setup=(qs = @SVector rand(6))

@btime my_ikine_Newton($T,$DHS,$qs)