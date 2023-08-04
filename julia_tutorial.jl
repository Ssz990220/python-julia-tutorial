### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ fa37f3ed-f7a9-4f44-ab8e-ad37384de12d
using PlutoUI

# ╔═╡ 3b023ad6-7b1b-4cbf-ae3a-3272ef119dbd
using LinearAlgebra

# ╔═╡ 8fdda55b-14f3-4609-b900-6a81cbcd68e1
using Quaternions

# ╔═╡ 0feb40f4-a61d-4bd6-ada1-9eaf63345b7d
using BenchmarkTools

# ╔═╡ 55939e3b-8218-4f82-bb2b-b62571361f18
using StaticArrays

# ╔═╡ a36b6e6d-0bfc-4586-83c3-dcead85dd7c9
using Rotations, Test

# ╔═╡ 6bb5a096-3441-4bea-9c3f-e8cd5ac43079
md"当你打开这个脚本的时候，你就已经发现Julia的第一个弊端了——首次运行时间较长"

# ╔═╡ 84356ebc-d29f-4163-ae84-1002e4ba8968
md"
每一个Pluto Notebook都是一个独立的环境，如果主环境中没有对应的包，它会自动安装并在运行脚本时编译"

# ╔═╡ 0a74ce15-535e-47c8-a625-a74daf9ebab2
md"# Basic"

# ╔═╡ 7d6ab5b5-9fe6-4c01-882c-aaace41553c5
md"## Elements"

# ╔═╡ b7ed1452-115c-4cce-bdc6-444f196a077e
md"### Number"

# ╔═╡ 852fb4fa-c7db-4a65-8288-9735babe5385
a = 0.0

# ╔═╡ ca5c113c-110f-4e92-ab7a-8c00ee4c0194
typeof(a)

# ╔═╡ 9335038c-3dd9-4a5d-b3f4-71653052e526
md"注意，在Julia中0和0.0需要严格区分"

# ╔═╡ 54275c6d-7ccb-449d-a073-dd3c41fe01c1
b = 0

# ╔═╡ 2faf85b2-111b-4bdd-8bf8-6e632f2e08db
typeof(b)

# ╔═╡ 03eff147-0cfc-42a5-82ad-c52edcbb1941
md"### Vector"

# ╔═╡ d76efba0-094b-4c68-9517-98acbf383ab7
md"Julia 中向量和矩阵是明确区分的两种容器"

# ╔═╡ 8e2cf5a5-08ca-4093-a389-2ffe5666f130
Vₐ = [1.0,2.0,3.0]

# ╔═╡ 1a6a1ab5-8f96-4073-82ad-53aa2c893fa7
V₂ = rand(3)	# rand(3)与Matlab不同，是生成一个长度为3的向量

# ╔═╡ 8f599810-6266-4f58-867a-9dbc986889c6
typeof(Vₐ)

# ╔═╡ 5f1dea4f-0b69-4e82-9d22-7a8b7fb20f90
md"向量是1维“数组”"

# ╔═╡ a4707a21-94bb-43f3-bfa2-0ebea2ce90d2
md"其索引的方式与MATLAB相同，只不过需要使用中括号"

# ╔═╡ ad07e5d1-900c-47c0-9e51-75e932732519
Vₐ[1]

# ╔═╡ 455c2183-3c7c-4731-82cd-c6228f100b41
Vₐ[1:2]

# ╔═╡ 93f846cc-613d-427d-aa63-644509518a86
Vₐ[:]

# ╔═╡ cbebc39c-5944-4b07-8863-877dfb5da7e6
size(Vₐ)

# ╔═╡ 1e4373fb-0f48-490e-98b3-43f9ce6348db
size(Vₐ)[1]

# ╔═╡ c007c401-74f1-483d-ab9a-89599aaf358f
md"### Matrix"

# ╔═╡ 96d2053d-b089-4d3e-822f-9f78c85fad5d
M₁ = [1.0 1.0 1.0]

# ╔═╡ bc990058-ee2f-4fab-8634-eb12f5f320bc
size(M₁)

# ╔═╡ ee917d88-672f-4471-b368-3b47c53ce54c
M₂ = rand(3,3)

# ╔═╡ ce92904a-4985-4ee9-91b9-10bf8fd98cc2
M₃ = zeros(3,3)

# ╔═╡ 2cab9688-0077-4dd7-bad8-8d14b8ed5d0d
[M₂ M₃]

# ╔═╡ a02366fd-0a92-479d-af6c-7a16c295a6b5
md"Julia中好像没有eye函数？但是其对单位阵的理解更加”数学“"

# ╔═╡ 3206e49c-a731-4306-b500-b11b237afc7d
M₃ * I

# ╔═╡ cce02ee3-3ce8-4643-a101-5ea859688764
md"## 基本语法"

# ╔═╡ f1c8b5ca-f413-47dd-b3c2-fcc9d150b8cf
md"### 函数"

# ╔═╡ d7857ce1-2883-4af6-ad4e-defc6942bd77
md"与Matlab不同，Julia的最大区别在于，函数不需要定义在独立的文件中"

# ╔═╡ 6ccfdd70-a6fa-4a44-b251-62b6ab4550ab
function matmul(A,B)
	return A*B
end

# ╔═╡ 08ad09b0-cd49-49c3-9e99-5cdf2b65edc5
md"并且具有先天的多态性"

# ╔═╡ 5bcd3ad8-efef-42f9-9c1c-0e16715f6f93
matmul(0.0,1.0)

# ╔═╡ 8718d646-f3b6-4ee2-8fbc-5d4bc4c78f2e
matmul(rand(3,3),rand(3,3))

# ╔═╡ ec753caa-4da9-452a-b192-d4a17d7220ec
q₁ = Quaternion(1.0); q₂ = Quaternion(2.0)

# ╔═╡ fa02053f-5dce-4e88-93ba-3756bd9b1205
matmul(q₁,q₂)

# ╔═╡ 1bf34708-bc98-4124-9056-91708542dd93
md"有时这回造成一些疑惑，所以Julia允许指定函数输入类型"

# ╔═╡ d6931189-eaf2-4e5b-8541-bd709cd4e824
function matmul_Only_for_mat(A::Matrix{Float64},B::Matrix{Float64})
	A*B
end

# ╔═╡ c4f4c4fb-80be-4c3d-98ae-241dc6f69d02
matmul_Only_for_mat(rand(3,3),rand(3,3))

# ╔═╡ a23455f1-6f43-4da0-90e7-1e7ed272b119
matmul_Only_for_mat(q₁,q₂)	# throw error

# ╔═╡ ef1664fe-5b17-40c4-828c-1deecd1aa0eb
md"也可以这样写"

# ╔═╡ b3b64508-a097-4307-994e-bd31e9065f89
function matmul_Only_for_mat2(A::T,B::T) where {T<:Matrix{Float64}}
	A*B
end

# ╔═╡ 979f2d6b-4516-4bd7-a09d-b5a1a005845d
md"### 其他"

# ╔═╡ a25d7f84-e1c9-47be-a160-aa27e3b2b424
for i = 1:10
	if i != 2
		@show i
	end
end

# ╔═╡ 0d2e8790-efd2-4309-bcba-ec35c20a8922
md"`if`指令可以在一行内写完"

# ╔═╡ 8e388445-3508-4b41-8ba6-ec2f01a41a8f
begin
	box = @bind isTrue CheckBox()

	md"isTrue: $box"
end

# ╔═╡ 9916740e-a47c-4ba1-97fa-a953b1641b83
begin
	text = isTrue ? "True" : "False"
	@show text
end

# ╔═╡ beda9df5-6c35-43f5-a7ad-9ee51124ecc2
md"`for`有时候也可以"

# ╔═╡ b5b44a95-9a61-410c-acb1-60ae0c536439
[1 for i = 1:10]

# ╔═╡ f30bb721-28b5-4803-a9eb-a94ecf06ab50
md"对于Vector来说，还有一些特殊的操作"

# ╔═╡ f9d70a6b-ee65-401a-b0d3-886eb14617ea
V₄ = rand(10)

# ╔═╡ 5e13e236-a34c-4a46-aa3d-5387a06fddde
for v ∈ V₄  # for v\in[tab] V\_4[tab]
	@show v
end

# ╔═╡ 323991ca-c946-454f-8c91-5e62c4e63d6a
for i ∈ eachindex(V₄)
	@show V₄[i]
end

# ╔═╡ b87e951b-4de0-4039-8a1a-dc89bb2eab61
md"# 小试牛刀"

# ╔═╡ 2e15d7f4-1ecf-4ac4-81ea-d2b9b7f467af
md"1) 创建一个 元素为“五个随机浮点数数组“的 向量，结果类型为：Vector{Vector{Float64}} 
"

# ╔═╡ 4bbf320a-4358-409d-a621-eeefd654f2ad
# ╠═╡ disabled = true
#=╠═╡
Vᵥ = missing # your code here
  ╠═╡ =#

# ╔═╡ 3df06314-6955-4370-887f-00158573aa48
md"2) 对向量中，每个长度为五的向量求均值"

# ╔═╡ 4a57f7a3-0096-4b35-83fb-5258d3f48de7
function vector_avg(V)
	# your Code here
end

# ╔═╡ 9aa87cad-7abf-4daf-ab35-79dd34a62905
#=╠═╡
vector_avg.(Vᵥ)
  ╠═╡ =#

# ╔═╡ 8d293f7d-e257-4598-b9e3-b3929a6c466e
md"# StaticArrays"

# ╔═╡ 77bb765b-70b0-49dd-9e5d-a756b90a6300
md"如果你对程序执行的效率很着迷，或者想看看自己的程序到底能跑多快，抑或是想知道一些非常简单地就能加速程序执行的技巧，请往下看"

# ╔═╡ d84ae82c-c751-4f06-81de-aa5f10f0987e
md"### 测量函数运行时间"

# ╔═╡ 2a5c9755-abba-42aa-a521-213e31f5f206
md"首先一个非常常用的功能是：统计函数执行时间，这里我们需要用到`BenchmarkTools`工具箱"

# ╔═╡ a4021507-6b61-4035-b851-0c11aea57395
md"`BenchmarkTools`提供了几个非常简单的工具来测量时间,`@btime`和`@benchmark`"

# ╔═╡ a8a5f4bb-d83c-4f77-86ad-a7b12de325d4
@btime M₂*M₃

# ╔═╡ 9598426a-0647-4c71-9014-a0ff43e348b5
@benchmark M₂*M₃

# ╔═╡ 029f23e4-eec7-434a-a523-c08aec1e794a
@btime matmul(M₂,M₃)

# ╔═╡ 11ebf017-d490-4b21-8c1c-ee7b1e3fa8c0
md"有些时候函数的输入你希望随机生成，同样可以"

# ╔═╡ 471265ca-c8cb-4abb-900a-73ef69315654
@btime matmul(A,B) setup=(begin; A = rand(3,3); B = rand(3,3); end;)

# ╔═╡ 0108b29b-ef39-4c4f-b007-258ce5871b50
md"好像更快了？这是因为setup的时间是不算在内的，setup好的数据的读取时间也不算在内，而直接测量`matmul(A,B)`则包含了从内存读取数据的时间,我们可以用过`@btime matmul($A,$B)`的方式来避免内存读取的时间也被统计"

# ╔═╡ d4454e72-061f-494d-84d7-c04ce472b9bf
@btime matmul($M₂,$M₃)

# ╔═╡ 0801734c-4d25-441f-adc8-cf10636938ed
md"合理多了"

# ╔═╡ b1dabfba-9004-4546-b24d-ce7234bb87f3
md"我们可以在Julia中非常方便地使用`@btime`来测量一个函数运行的时间，并用setup为其准备运行数据"

# ╔═╡ 65ff790b-e418-4bba-bbf4-0251760d6c3c
md"### StaticArrays"

# ╔═╡ e0ed58a1-872e-4ce0-a8a5-52db985425a7
md"绝大多数情况下，矩阵的大小是已知的；还有部分情况下，矩阵的值是不会改变的，这些不变性给我们提供了很多对代码进行优化的可能。先看一个例子"

# ╔═╡ 0edd0df4-6754-4996-8458-583aa5c16103
@btime A*B setup=(begin; A = rand(3,3); B = rand(3,3); end;)

# ╔═╡ 93f6f91b-baf6-45ad-8fb1-8810885a317a
@btime A*B setup=(begin; A = @SMatrix rand(3,3); B = @SMatrix rand(3,3); end;)

# ╔═╡ bebec5b4-e56c-4750-a138-955fb87b5b0f
md"效果非常显著，数倍的效率提升.换一个例子，比如说四元数乘法"

# ╔═╡ be03bf71-1afb-420e-8f68-864aeee5788a
function mulquat(q1,q2)
	result1 = q1[1] * q2[1] - q1[2] * q2[2] - q1[3] * q2[3] - q1[4] * q2[4];
	result2 = q1[1] * q2[2] + q1[2] * q2[1] + q1[3] * q2[4] - q1[4] * q2[3];
	result3 = q1[1] * q2[3] + q1[3] * q2[1] + q1[4] * q2[2] - q1[2] * q2[4];
	result4 = q1[1] * q2[4] + q1[4] * q2[1] + q1[2] * q2[3] - q1[3] * q2[2];
	return [result1, result2, result3, result4]
end

# ╔═╡ fe1162d0-908d-4cae-bd5d-d6183f9dc512
@btime mulquat(q1,q2) setup=(begin; q1 = rand(4); q2 = rand(4); end;);

# ╔═╡ 918f3d55-9ab0-410a-8866-15b98b26d145
function mulquatS(q1::SVector{4,Float64},q2::SVector{4,Float64})
	result1 = q1[1] * q2[1] - q1[2] * q2[2] - q1[3] * q2[3] - q1[4] * q2[4];
	result2 = q1[1] * q2[2] + q1[2] * q2[1] + q1[3] * q2[4] - q1[4] * q2[3];
	result3 = q1[1] * q2[3] + q1[3] * q2[1] + q1[4] * q2[2] - q1[2] * q2[4];
	result4 = q1[1] * q2[4] + q1[4] * q2[1] + q1[2] * q2[3] - q1[3] * q2[2];
	return @SVector [result1, result2, result3, result4]
end

# ╔═╡ 4a7156f6-4531-4059-a9bb-c1adca1c1c8a
@btime mulquatS(q1,q2) setup=(begin;q1 = @SVector rand(4); q2 = @SVector rand(4); end;);

# ╔═╡ f6b60400-c34c-4ee9-83b9-1fbbe889a329
md"直接上正运动学"

# ╔═╡ 55a67643-47e5-4fe3-be40-43aebccc289a
begin
	function Tᵢⱼ(θᵢ,i,DH)
		θ = θᵢ + DH[i,1];
		Tᵢⱼ₁=[cos(θ) 	-sin(θ) 	0 	0;
			 sin(θ) 	cos(θ) 	0 	0;
			 0 			0 			1 	DH[i,3];
			 0 			0 			0 	1];
		Tᵢⱼ₂ =  [1 0 				0 				DH[i,2];
			  0 cos(DH[i,4]) 	-sin(DH[i,4])  	0;
			  0 sin(DH[i,4]) 	cos(DH[i,4]) 	0;
			  0 0 				0 				1];
		return Tᵢⱼ₁*Tᵢⱼ₂
	end
		
	function FkineDH(θ,DH)
		T = diagm([1.0,1.0,1.0,1.0])
		n = size(DH,1)
		@inbounds for i in 1:n
			T = T*Tᵢⱼ(θ[i],i,DH)
		end
		return T
	end
	md"再用普通Matrix"
end

# ╔═╡ 8bddd750-6f1a-4a60-bee8-647d65a61e94
DH = [0.0  175.0  495.0    -π/2;
				  -π/2  900.0   0.0     0.0;
				  0.0   170.0   0.0     -π/2;
				  0.0   0.0     960.0   π/2;
				  0.0   0.0     0.0     -π/2;
				  π     0.0     135.0   0.0];

# ╔═╡ fd271c69-1bba-455f-8eb8-0848b2de2166
DHS = @SMatrix [0.0  175.0  495.0    -π/2;
				  -π/2  900.0   0.0     0.0;
				  0.0   170.0   0.0     -π/2;
				  0.0   0.0     960.0   π/2;
				  0.0   0.0     0.0     -π/2;
				  π     0.0     135.0   0.0];

# ╔═╡ 42e917b0-ac4a-40b1-9af3-e64a866516c7
@btime FkineDH(qs,$DH) setup=(qs = rand(6));

# ╔═╡ 6849ed9a-68b9-4a26-8778-f3625d9b5b75
md"大概30倍的差距"

# ╔═╡ 68e262da-8517-4fc8-bed7-392642af4faa
md"我相信已经足够说明这样的简单的方法带来的巨大优势了"

# ╔═╡ 72f9b2c5-2463-4a0a-b1a0-92f1ef27539c
md"## StaticArrays的使用方法"

# ╔═╡ 6f58b35e-b626-42c5-a5ff-4b94e9af4403
md"StaticArrays的使用方法于基本矩阵几乎无异，但是要注意，当单个矩阵/向量元素数量超过100时，请使用常规矩阵，否则电脑会成砖"

# ╔═╡ 71e74871-e49f-4b78-a130-5f1dd86b253a
rand(3,3)

# ╔═╡ f0e1d3a0-6cfb-44a3-aa46-271d9bccf010
@SMatrix rand(3,3)

# ╔═╡ 85d8e466-7465-478e-b723-842b21140a1e
zeros(3,3)

# ╔═╡ 6ae11fd9-1600-49a1-90ee-5a02599b89f9
@SMatrix zeros(3,3)

# ╔═╡ 6db61629-14e6-4a86-9a51-9ac3a1e0b41e
[1.0 2.0 3.0;
 2.0 3.0 4.0]

# ╔═╡ 1df2866c-ccff-4265-a1ac-486cbadba49e
@SMatrix [1.0 2.0 3.0;
 		  2.0 3.0 4.0]

# ╔═╡ b1b71927-fd4a-4ce5-8da2-14391adfb2c7
md"同时还提供了SVector"

# ╔═╡ 79cc473c-46c8-4981-91a8-4f9148d96f81
rand(3)

# ╔═╡ 3a749ef7-6692-4cfd-ad61-246cded8a703
@SVector rand(3)

# ╔═╡ 04972347-40a6-42e4-90a9-c4308f793f15
@SVector [1,2,3]

# ╔═╡ 1a0e563a-6937-4b94-9a88-6372261f0a89
md"### 特性"

# ╔═╡ b63db667-de8e-4faf-b770-197c0a401d0f
md"
1. S矩阵，S向量赋值后无法修改，只能替换"

# ╔═╡ da9c6a2c-c694-458a-bca3-ee1139e8fcee
md"2. S矩阵，S向量的索引需要特殊处理"

# ╔═╡ c24e30b0-6eba-4af2-814d-8d1067b8d9bb
md"`SMatrix`与`SVector`的索引比较特殊,当使用:进行索引时或索引一个元素时不会出现异常"

# ╔═╡ f4e6ad63-3f46-4f50-ad1d-f4bb4104e1cf
SMat = @SMatrix rand(8,8)

# ╔═╡ b4dd1385-f1ba-4b66-b5e2-240792e2f3e6
SMat[1,1] = 0.0

# ╔═╡ eb17ad22-2d27-474d-b158-6774b41c81bf
SMat[:,3]

# ╔═╡ 772fb6df-deb8-486f-a8ce-ec5198dcbba1
SMat[3,:]

# ╔═╡ 96441ef8-0cfb-4d19-bbda-c02d2988bdad
md"但当部分索引时，常规的索引方式会使得S矩阵退化为常规矩阵"

# ╔═╡ 3e992abf-f920-4d59-bb81-02a76257c207
SMat[1:3,:]

# ╔═╡ 11877792-8334-404e-aa5d-1878cb2add78
md"S矩阵的索引同样需要用S向量"

# ╔═╡ 6abe470d-14be-4183-a28d-1f7682c77e8a
SMat[(@SVector [1,2,3]),:]

# ╔═╡ f5b09fc3-f9a5-4771-9e2a-ad6392fa3ede
md"3. S矩阵,S向量可以通过连接函数创建"

# ╔═╡ 636a6a57-45c6-486f-84c9-6da7afde74de
SMat₂ = @SMatrix rand(3,3); SMat₃ = @SMatrix rand(3,3);

# ╔═╡ aef4fcc5-1c84-48db-9ad7-e163b6df6c95
[SMat₂ SMat₃]

# ╔═╡ 7fcdb68f-3a82-4cf6-8441-87b18f382e8c
md"4. S向量是列向量"

# ╔═╡ ac287861-daea-48be-836a-474161d7d55a
SMat₄ = @SMatrix [1.0 2.0 3.0;4.0 5.0 6.0]; SVec₁ = @SVector ones(3)

# ╔═╡ 8850fd86-e546-4f28-adf8-82f8a9098c98
SMat₄*SVec₁

# ╔═╡ fe19ffd9-f67b-4b54-b195-5ac08911280d
SVec₁*SMat₄

# ╔═╡ 0e6f27df-4419-455c-9acd-12d380439daa
[SVec₁;SVec₁]

# ╔═╡ a7b59b78-ee2f-43e3-bbeb-b9d3e1bdda3f
[SMat₄; SVec₁']

# ╔═╡ 6d53d3f0-d3c5-45c6-983e-e40efd2d6916
[(@SMatrix rand(3,3)) SVec₁]

# ╔═╡ 9cc817dd-3828-4043-85e8-10691cfe9df6
md"# 小试牛刀2"

# ╔═╡ 5d9a017d-b102-44f4-8a0f-d9408ea4f14c
md"1) 创建一个长度为100，元素为“SVector{3,Float64}“的向量（比如，100个3D点），结果类型为：Vector{SVector{3,Float64}}，注意，不要创建长度为100的SVector。
"

# ╔═╡ e9965ce6-8590-4cc5-b22b-a700ddfa22b0
pointArray = missing

# ╔═╡ 23ec2ed2-0987-42c8-beec-378ad3604e01
typeof(pointArray) == Vector{SVector{3,Float64}}

# ╔═╡ ea2b6c0d-86e1-47f5-8ef3-19cabd2f79d1
R = SMatrix{3,3,Float64,9}(rand(QuatRotation))

# ╔═╡ 460d4023-cf0d-4fc1-a9ff-ee9ac34f71ec
md"2) 将每个点经过$R$矩阵旋转"

# ╔═╡ 5ba5fc8b-6c45-47da-b123-e8cb4945c537
pointArrayRotated = missing

# ╔═╡ 15d41677-2871-4be5-ac9f-c9fb3f14e1b4
md"3) 用`@btime`测量旋转点集所花费的时间"

# ╔═╡ 213098cd-9d0e-4c85-bf6b-d04a77a14080


# ╔═╡ 9a6d7f5f-a406-4147-9123-2990d3c512f9
md"# Functions Lib"

# ╔═╡ 3ef188a4-dba5-47ff-85c7-faaffeeb3ab6
hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]))

# ╔═╡ a83aa858-d2bc-4f01-8f3d-4ffb8393a30f
md"给出一个参考的方法
1. 创建一个 元素为“五个随机浮点数数组“的 向量
```julia
Vᵥ = [rand(5) for i = 1:5]
```

2. 对向量中，每个长度为五的向量求均值
```julia
function vector_avg(V::Vector{Float64})
	sum(V)/size(V)[1]
end
```

注意，在函数后参数前加“。”的作用是，将函数作用于输入的Vector的每一个元素之上，返回由每个元素结果组成的Vector
" |> hint

# ╔═╡ ac579c3c-f735-4c7b-b987-a41c5973d981
md"给出一个参考的方法
1. 创建一个长度为100，元素为“SVector{3,Float64}“的向量（比如，100个3D点），结果类型为：Vector{SVector{3,Float64}}，注意，不要创建长度为100的SVector。
```julia
pointArray = [(@SVector rand(3)) for i = 1:100]
```

2) 将每个点经过$R$矩阵旋转
```julia
pointArrayRotated = [R] .* pointArray
[R*point for point ∈ pointArray]
```

3) 用`@btime`测量旋转点集所花费的时间
```julia
@btime $R * $pointArray[1]
@btime [$R] .* $pointArray
@btime [$R*point for point ∈ $pointArray]
```

注意，在函数后参数前加“。”的作用是，将函数作用于输入的Vector的每一个元素之上，返回由每个元素结果组成的Vector
" |> hint

# ╔═╡ 56ac2b98-76bd-4097-a1fe-e88a6530bf91
function eye(n, T = Float64)
	f(i,j) = T(i == j)
	return StaticArrays.sacollect(SMatrix{n,n}, f(i,j) for i in 1:n, j in 1:n)
end

# ╔═╡ a46a859b-c63d-4b96-b040-ddb2816df01d
M₄ = eye(3)

# ╔═╡ 077a87d6-e1dd-4cd2-bae2-37ca12c02418
begin
	function TᵢⱼS(θᵢ,i,DH)
		θ = θᵢ + DH[i,1];
		Tᵢⱼ₁=@SMatrix [cos(θ) 	-sin(θ) 	0 	0;
			 sin(θ) 	cos(θ) 	0 	0;
			 0 			0 			1 	DH[i,3];
			 0 			0 			0 	1];
		Tᵢⱼ₂=@SMatrix [1 0 				0 				DH[i,2];
			  0 cos(DH[i,4]) 	-sin(DH[i,4])  	0;
			  0 sin(DH[i,4]) 	cos(DH[i,4]) 	0;
			  0 0 				0 				1];
		return Tᵢⱼ₁*Tᵢⱼ₂
	end
		
	function FkineDHS(θ,DH)
		T = eye(4);
		n = size(DH,1)
		@inbounds for i in 1:n
			T = T*TᵢⱼS(θ[i],i,DH)
		end
		return T
	end
	md"先用SMatrix写一套"
end

# ╔═╡ b4591a07-6b8a-4a22-a7e5-f1e9548c6729
@btime FkineDHS(qs,$DHS) setup=(qs = @SVector rand(6));

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Quaternions = "94ee1d12-ae83-5a48-8b1c-48b8ff168ae0"
Rotations = "6038ab10-8711-5258-84ad-4b1120ba62dc"
StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[compat]
BenchmarkTools = "~1.3.2"
PlutoUI = "~0.7.52"
Quaternions = "~0.7.4"
Rotations = "~1.5.1"
StaticArrays = "~1.6.2"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.2"
manifest_format = "2.0"
project_hash = "b748282ed0e306836798e6e935570be3ecc47eea"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "91bd53c39b9cbfb5ef4b015e8b582d344532bd0a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "d9a9701b899b30332bbcb3e1679c41cce81fb0e8"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.3.2"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "716e24b21538abc91f6205fd1d8363f39b442851"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.2"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "e47cd150dbe0443c3a3651bc5b9cbd5576ab75b7"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.52"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "9673d39decc5feece56ef3940e5dafba15ba0f81"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.1.2"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "7eb1686b4f04b82f96ed7a4ea5890a4f0c7a09f1"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[deps.Quaternions]]
deps = ["LinearAlgebra", "Random", "RealDot"]
git-tree-sha1 = "da095158bdc8eaccb7890f9884048555ab771019"
uuid = "94ee1d12-ae83-5a48-8b1c-48b8ff168ae0"
version = "0.7.4"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RealDot]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "9f0a1b71baaf7650f4fa8a1d168c7fb6ee41f0c9"
uuid = "c1ae055f-0cd5-4b69-90a6-9a35b1a98df9"
version = "0.1.0"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Rotations]]
deps = ["LinearAlgebra", "Quaternions", "Random", "StaticArrays"]
git-tree-sha1 = "54ccb4dbab4b1f69beb255a2c0ca5f65a9c82f08"
uuid = "6038ab10-8711-5258-84ad-4b1120ba62dc"
version = "1.5.1"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore"]
git-tree-sha1 = "9cabadf6e7cd2349b6cf49f1915ad2028d65e881"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.6.2"
weakdeps = ["Statistics"]

    [deps.StaticArrays.extensions]
    StaticArraysStatisticsExt = "Statistics"

[[deps.StaticArraysCore]]
git-tree-sha1 = "36b3d696ce6366023a0ea192b4cd442268995a0d"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.2"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "aadb748be58b492045b4f56166b5188aa63ce549"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.7"

[[deps.URIs]]
git-tree-sha1 = "074f993b0ca030848b897beff716d93aca60f06a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╟─6bb5a096-3441-4bea-9c3f-e8cd5ac43079
# ╟─84356ebc-d29f-4163-ae84-1002e4ba8968
# ╟─fa37f3ed-f7a9-4f44-ab8e-ad37384de12d
# ╟─0a74ce15-535e-47c8-a625-a74daf9ebab2
# ╟─7d6ab5b5-9fe6-4c01-882c-aaace41553c5
# ╟─b7ed1452-115c-4cce-bdc6-444f196a077e
# ╠═852fb4fa-c7db-4a65-8288-9735babe5385
# ╠═ca5c113c-110f-4e92-ab7a-8c00ee4c0194
# ╟─9335038c-3dd9-4a5d-b3f4-71653052e526
# ╠═54275c6d-7ccb-449d-a073-dd3c41fe01c1
# ╠═2faf85b2-111b-4bdd-8bf8-6e632f2e08db
# ╟─03eff147-0cfc-42a5-82ad-c52edcbb1941
# ╟─d76efba0-094b-4c68-9517-98acbf383ab7
# ╠═8e2cf5a5-08ca-4093-a389-2ffe5666f130
# ╠═1a6a1ab5-8f96-4073-82ad-53aa2c893fa7
# ╠═8f599810-6266-4f58-867a-9dbc986889c6
# ╟─5f1dea4f-0b69-4e82-9d22-7a8b7fb20f90
# ╟─a4707a21-94bb-43f3-bfa2-0ebea2ce90d2
# ╠═ad07e5d1-900c-47c0-9e51-75e932732519
# ╠═455c2183-3c7c-4731-82cd-c6228f100b41
# ╠═93f846cc-613d-427d-aa63-644509518a86
# ╠═cbebc39c-5944-4b07-8863-877dfb5da7e6
# ╠═1e4373fb-0f48-490e-98b3-43f9ce6348db
# ╟─c007c401-74f1-483d-ab9a-89599aaf358f
# ╠═96d2053d-b089-4d3e-822f-9f78c85fad5d
# ╠═bc990058-ee2f-4fab-8634-eb12f5f320bc
# ╠═ee917d88-672f-4471-b368-3b47c53ce54c
# ╠═ce92904a-4985-4ee9-91b9-10bf8fd98cc2
# ╠═2cab9688-0077-4dd7-bad8-8d14b8ed5d0d
# ╠═a46a859b-c63d-4b96-b040-ddb2816df01d
# ╟─a02366fd-0a92-479d-af6c-7a16c295a6b5
# ╠═3b023ad6-7b1b-4cbf-ae3a-3272ef119dbd
# ╠═3206e49c-a731-4306-b500-b11b237afc7d
# ╟─cce02ee3-3ce8-4643-a101-5ea859688764
# ╟─f1c8b5ca-f413-47dd-b3c2-fcc9d150b8cf
# ╟─d7857ce1-2883-4af6-ad4e-defc6942bd77
# ╠═6ccfdd70-a6fa-4a44-b251-62b6ab4550ab
# ╟─08ad09b0-cd49-49c3-9e99-5cdf2b65edc5
# ╠═5bcd3ad8-efef-42f9-9c1c-0e16715f6f93
# ╠═8718d646-f3b6-4ee2-8fbc-5d4bc4c78f2e
# ╠═8fdda55b-14f3-4609-b900-6a81cbcd68e1
# ╠═ec753caa-4da9-452a-b192-d4a17d7220ec
# ╠═fa02053f-5dce-4e88-93ba-3756bd9b1205
# ╟─1bf34708-bc98-4124-9056-91708542dd93
# ╠═d6931189-eaf2-4e5b-8541-bd709cd4e824
# ╠═c4f4c4fb-80be-4c3d-98ae-241dc6f69d02
# ╠═a23455f1-6f43-4da0-90e7-1e7ed272b119
# ╟─ef1664fe-5b17-40c4-828c-1deecd1aa0eb
# ╠═b3b64508-a097-4307-994e-bd31e9065f89
# ╟─979f2d6b-4516-4bd7-a09d-b5a1a005845d
# ╠═a25d7f84-e1c9-47be-a160-aa27e3b2b424
# ╟─0d2e8790-efd2-4309-bcba-ec35c20a8922
# ╟─8e388445-3508-4b41-8ba6-ec2f01a41a8f
# ╠═9916740e-a47c-4ba1-97fa-a953b1641b83
# ╟─beda9df5-6c35-43f5-a7ad-9ee51124ecc2
# ╠═b5b44a95-9a61-410c-acb1-60ae0c536439
# ╟─f30bb721-28b5-4803-a9eb-a94ecf06ab50
# ╠═f9d70a6b-ee65-401a-b0d3-886eb14617ea
# ╠═5e13e236-a34c-4a46-aa3d-5387a06fddde
# ╠═323991ca-c946-454f-8c91-5e62c4e63d6a
# ╟─b87e951b-4de0-4039-8a1a-dc89bb2eab61
# ╟─2e15d7f4-1ecf-4ac4-81ea-d2b9b7f467af
# ╠═4bbf320a-4358-409d-a621-eeefd654f2ad
# ╟─3df06314-6955-4370-887f-00158573aa48
# ╠═4a57f7a3-0096-4b35-83fb-5258d3f48de7
# ╠═9aa87cad-7abf-4daf-ab35-79dd34a62905
# ╟─a83aa858-d2bc-4f01-8f3d-4ffb8393a30f
# ╟─8d293f7d-e257-4598-b9e3-b3929a6c466e
# ╟─77bb765b-70b0-49dd-9e5d-a756b90a6300
# ╟─d84ae82c-c751-4f06-81de-aa5f10f0987e
# ╟─2a5c9755-abba-42aa-a521-213e31f5f206
# ╠═0feb40f4-a61d-4bd6-ada1-9eaf63345b7d
# ╟─a4021507-6b61-4035-b851-0c11aea57395
# ╠═a8a5f4bb-d83c-4f77-86ad-a7b12de325d4
# ╠═9598426a-0647-4c71-9014-a0ff43e348b5
# ╠═029f23e4-eec7-434a-a523-c08aec1e794a
# ╠═11ebf017-d490-4b21-8c1c-ee7b1e3fa8c0
# ╠═471265ca-c8cb-4abb-900a-73ef69315654
# ╟─0108b29b-ef39-4c4f-b007-258ce5871b50
# ╠═d4454e72-061f-494d-84d7-c04ce472b9bf
# ╟─0801734c-4d25-441f-adc8-cf10636938ed
# ╟─b1dabfba-9004-4546-b24d-ce7234bb87f3
# ╟─65ff790b-e418-4bba-bbf4-0251760d6c3c
# ╟─e0ed58a1-872e-4ce0-a8a5-52db985425a7
# ╠═55939e3b-8218-4f82-bb2b-b62571361f18
# ╠═0edd0df4-6754-4996-8458-583aa5c16103
# ╠═93f6f91b-baf6-45ad-8fb1-8810885a317a
# ╟─bebec5b4-e56c-4750-a138-955fb87b5b0f
# ╟─be03bf71-1afb-420e-8f68-864aeee5788a
# ╠═fe1162d0-908d-4cae-bd5d-d6183f9dc512
# ╟─918f3d55-9ab0-410a-8866-15b98b26d145
# ╠═4a7156f6-4531-4059-a9bb-c1adca1c1c8a
# ╟─f6b60400-c34c-4ee9-83b9-1fbbe889a329
# ╟─077a87d6-e1dd-4cd2-bae2-37ca12c02418
# ╟─55a67643-47e5-4fe3-be40-43aebccc289a
# ╠═8bddd750-6f1a-4a60-bee8-647d65a61e94
# ╠═fd271c69-1bba-455f-8eb8-0848b2de2166
# ╠═42e917b0-ac4a-40b1-9af3-e64a866516c7
# ╠═b4591a07-6b8a-4a22-a7e5-f1e9548c6729
# ╟─6849ed9a-68b9-4a26-8778-f3625d9b5b75
# ╟─68e262da-8517-4fc8-bed7-392642af4faa
# ╟─72f9b2c5-2463-4a0a-b1a0-92f1ef27539c
# ╟─6f58b35e-b626-42c5-a5ff-4b94e9af4403
# ╠═71e74871-e49f-4b78-a130-5f1dd86b253a
# ╠═f0e1d3a0-6cfb-44a3-aa46-271d9bccf010
# ╠═85d8e466-7465-478e-b723-842b21140a1e
# ╠═6ae11fd9-1600-49a1-90ee-5a02599b89f9
# ╠═6db61629-14e6-4a86-9a51-9ac3a1e0b41e
# ╠═1df2866c-ccff-4265-a1ac-486cbadba49e
# ╟─b1b71927-fd4a-4ce5-8da2-14391adfb2c7
# ╠═79cc473c-46c8-4981-91a8-4f9148d96f81
# ╠═3a749ef7-6692-4cfd-ad61-246cded8a703
# ╠═04972347-40a6-42e4-90a9-c4308f793f15
# ╟─1a0e563a-6937-4b94-9a88-6372261f0a89
# ╠═b63db667-de8e-4faf-b770-197c0a401d0f
# ╠═b4dd1385-f1ba-4b66-b5e2-240792e2f3e6
# ╟─da9c6a2c-c694-458a-bca3-ee1139e8fcee
# ╠═c24e30b0-6eba-4af2-814d-8d1067b8d9bb
# ╠═f4e6ad63-3f46-4f50-ad1d-f4bb4104e1cf
# ╠═eb17ad22-2d27-474d-b158-6774b41c81bf
# ╠═772fb6df-deb8-486f-a8ce-ec5198dcbba1
# ╟─96441ef8-0cfb-4d19-bbda-c02d2988bdad
# ╠═3e992abf-f920-4d59-bb81-02a76257c207
# ╠═11877792-8334-404e-aa5d-1878cb2add78
# ╠═6abe470d-14be-4183-a28d-1f7682c77e8a
# ╟─f5b09fc3-f9a5-4771-9e2a-ad6392fa3ede
# ╠═636a6a57-45c6-486f-84c9-6da7afde74de
# ╠═aef4fcc5-1c84-48db-9ad7-e163b6df6c95
# ╠═7fcdb68f-3a82-4cf6-8441-87b18f382e8c
# ╠═ac287861-daea-48be-836a-474161d7d55a
# ╠═8850fd86-e546-4f28-adf8-82f8a9098c98
# ╠═fe19ffd9-f67b-4b54-b195-5ac08911280d
# ╠═0e6f27df-4419-455c-9acd-12d380439daa
# ╠═a7b59b78-ee2f-43e3-bbeb-b9d3e1bdda3f
# ╠═6d53d3f0-d3c5-45c6-983e-e40efd2d6916
# ╟─9cc817dd-3828-4043-85e8-10691cfe9df6
# ╠═a36b6e6d-0bfc-4586-83c3-dcead85dd7c9
# ╟─5d9a017d-b102-44f4-8a0f-d9408ea4f14c
# ╠═e9965ce6-8590-4cc5-b22b-a700ddfa22b0
# ╠═23ec2ed2-0987-42c8-beec-378ad3604e01
# ╟─460d4023-cf0d-4fc1-a9ff-ee9ac34f71ec
# ╠═ea2b6c0d-86e1-47f5-8ef3-19cabd2f79d1
# ╠═5ba5fc8b-6c45-47da-b123-e8cb4945c537
# ╠═15d41677-2871-4be5-ac9f-c9fb3f14e1b4
# ╠═213098cd-9d0e-4c85-bf6b-d04a77a14080
# ╟─ac579c3c-f735-4c7b-b987-a41c5973d981
# ╟─9a6d7f5f-a406-4147-9123-2990d3c512f9
# ╟─3ef188a4-dba5-47ff-85c7-faaffeeb3ab6
# ╟─56ac2b98-76bd-4097-a1fe-e88a6530bf91
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
