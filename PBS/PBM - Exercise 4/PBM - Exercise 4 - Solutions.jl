### A Pluto.jl notebook ###
# v0.14.8

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 2210245d-9790-4103-ac91-76caf3c175fb
begin
	using Distributions
	using PlutoUI
	using LinearAlgebra
	using DelimitedFiles
	using DataFrames
	using KernelFunctions
	using Plots
	using Random
	using StatsPlots
	default(;linewidth=3.0, legendfontsize=15.0)
end

# ╔═╡ b9591cb5-81e4-4649-a524-0e8bbf92f35c
md"""
# Problem Sheet 4
"""

# ╔═╡ d0ca3350-6e7a-45b7-a535-25bf3818f89a
TableOfContents()

# ╔═╡ 52e4510d-352f-4cf2-bae5-fba2739fca5b
md"""
## 1. Gaussian process (GP) regression
"""

# ╔═╡ d3ebc367-26e2-40ce-8845-056d48f7f759
md"""
For the GP regression problem, we assume that data are generated as
```math
\begin{align}
y_i = f(x_i) + \nu_i \, \qquad i=1,\ldots, n
\end{align}
```
where the $\nu_i$ are independent, zero mean Gaussian noise variables within $E[\nu_i^2] = \sigma^2$
and $f(\cdot)$ has a GP prior with kernel $K(x,x')$. 
"""

# ╔═╡ 44f3ca60-88c4-4031-a1e6-19b5de86485f
md"""
### (a) [MATH] Show that the **Bayesian evidence** is given by
```math
\begin{align}
p(\mathbf{y})  = \frac{1}{(2\pi)^{n/2}
|\det(\mathbf{K}+\sigma^2\mathbf{I})|^{\frac{1}{2}}}
\exp\left[-\frac{1}{2} \mathbf{y}^T
(\mathbf{K}+\sigma^2\mathbf{I})^{-1} \mathbf{y}\right] 
\end{align}
```
### where $\mathbf{y} = (y_1,\ldots,y_n)$ and the kernel matrix is defined  by $\mathbf{K}_{ij} = K(x_i,x_j)$.

!!! tip
	Calculate the joint density of $\mathbf{y}$ and use the fact that $f(x_j)$ and $\nu_i$ are independent Gaussian random variables. Hence you can add the respective covariance matrices.
"""

# ╔═╡ a13616ef-a5b3-464e-bb37-82fff7d906eb
md"""
### Solution

The evidence can be computed via the joint distribution :
```math
\begin{align}
p(\mathbf{y})=\int p(\mathbf{y},\mathbf{f})d\mathbf{f}=\int p(\mathbf{y}|\mathbf{f})p(\mathbf{f})d\mathbf{f}
\end{align}
```

Where
```math
\begin{align}
p(\mathbf{y}|\mathbf{f}) =& \frac{1}{(2\pi)^{N/2}|\det(\sigma^2\mathbf{I})|^{\frac{1}{2}}}\exp\left[-\frac{1}{2}(\mathbf{y}-\mathbf{f})^\top \sigma^{-2}\mathbf{I} (\mathbf{y}-\mathbf{f})\right]\\
p(\mathbf{f})=&\frac{1}{(2\pi)^{N/2}|\det(\mathbf{K})|^{\frac{1}{2}}}\exp\left[-\frac{1}{2}\mathbf{f}^\top \mathbf{K}^{-1} \mathbf{f}\right]
\end{align}
```
In the integration one can do it the hard way and reformulate 
```math
\begin{align}
p(\mathbf{y}\mid\mathbf{f})p(\mathbf{f}) \equiv \mathcal{N}(y\mid 0,\sigma^2\mathbf{I}+\mathbf{K})\mathcal{N}(f\mid\overline{\mu},\overline{\Sigma})
\end{align}
```
using the identity
```math
\begin{align*}
 \mathcal{N}(x\mid m_1,\Sigma_1)\cdot \mathcal{N}(x\mid m_2,\Sigma_2) = &\mathcal{N}(m_1\mid m_2, (\Sigma_1+\Sigma_2)\mathcal{N}(x\mid \overline{m},\overline{\Sigma})\\
 \overline{m} = & (\Sigma_1^{-1}+\Sigma_2 ^{-1})^{-1}(\Sigma_1^{-1}m_1+\Sigma_2^{-1}m_2)\\
 \overline{\Sigma} =& (\Sigma_1^{-1}+\Sigma_2 ^{-1})^{-1}
\end{align*}
```
 Replacing $x$ by $\mathbf{f}$, the integral over $\mathbf{f}$ gives one and we recover the multivariate gaussian for $\mathbf{y}$.
 Or one can intuitively see that we are having a zero mean prior on the mean ($\mathbf{f}$), and therefore one can simply add the variances to get the final result.
"""

# ╔═╡ 9dc81225-9793-425d-8644-3fd4b0300962
md"""
### (b) [CODE] Create a Gaussian prior with zero mean and a RBF Kernel and sample from it on a grid
"""

# ╔═╡ 6ef75a26-e3e4-4ca4-a145-835d3c897f48
begin
	x_test = range(0, 10, length = 200)
	k = SqExponentialKernel() # This computes k(x, x') = exp(-0.5||x - x'||^2)
	K = kernelmatrix(k, x_test) + 1e-5I
	prior_f = MvNormal(K)
	S = 10 # Number of GP samples
end;

# ╔═╡ 07c98d47-40b1-4e25-8fc0-d51279554c92
plot(x_test, rand(prior_f, S); xlabel="x", ylabel="f", label="", alpha=0.5)

# ╔═╡ e81cb189-63d8-45b9-8549-5596823369f8
md"""
### (c) [MATH] Given a set of training data $(X,y)$, compute the predictive distribution of some test data $X_\text{test}$
"""

# ╔═╡ 3c586e73-351b-4e73-a8dd-6dd2b618f80a
md"""
### Solution

Given $f = f(X)$ and $f^*=f(X_\text{test})$, we know that the joint distribution $p(f, f^*) = \mathcal{N}(0, K)$, where $K$ is equal to :
```math
\begin{align}
K = \left(\begin{array}{cc} 
K_X & K_{X,X_{test}}\\
K_{X_{test}, X} & K_{X_{test}}
\end{array}\right)
\end{align}
```
Using the properties of Gaussian distributions we get the exact conditional $p(f^*|f) = \mathcal{N}(\mu(f), \Sigma)$ where $\mu(f) = K_{X_{test}, X} K_X^{-1}f$ and $\Sigma = K_{X_{test}} - K_{X_{test}, X} K_X^{-1} K_{X, X_{test}}$.

Now if we have some data $y$ we can compute the predictive distribution as :
```math
\begin{align}
    p(f^*|y) = \int p(f^*|f) p(f|y) df = \mathcal{N}(f^*| \mu^*,\Sigma^*)
\end{align}
```
where $\mu^* = K_{X_{test}, X} (K_X + \sigma^2 I )^{-1}y$ and $\Sigma^* =  K_{X_{test}} - K_{X_{test}, X} (K_X + \sigma^2 I)^{-1} K_{X, X_{test}}$
"""

# ╔═╡ d6a0df4f-22f2-4719-bd01-ac6cde1083b1
md"""
### (d) [CODE] Implement the predictive distribution and plot the predictive mean along with one standard error
"""

# ╔═╡ 6e64e61a-e52f-4246-945e-db7c2f5d1748
md"""
N  $(@bind N Slider(1:100; default=20, show_value=true))
"""

# ╔═╡ b24e157a-c415-44a0-a5a2-d020d7bcb8f3
md"""
logσ $(@bind logσ Slider(-8:1; default=-1, show_value=true))
"""

# ╔═╡ 1525a48a-01d3-4d3d-884f-69e9dbaddc91
begin
	rng = Random.MersenneTwister(42)
	X = rand(rng, Uniform(0, 10), N)
	σ = exp(logσ)
	y = sin.(X) + randn(rng, N) * σ
end;

# ╔═╡ 30fe2ca4-9c4e-45e9-9502-936ddf18d523
function pred_mean_and_cov(k, x_test, x, y)
    Kx = kernelmatrix(k, x)
	Σ = Kx + σ^2 * I
    Kxtest_x = kernelmatrix(k, x_test, x)
    Kxtest = kernelmatrix(k, x_test) + 1e-5I
    return Kxtest_x * inv(Σ) * y, Kxtest - Kxtest_x * inv(Σ) * Kxtest_x'
end;

# ╔═╡ bcefa4a9-04a6-4de8-91b2-170e5a309918
m, C = pred_mean_and_cov(k, x_test, X, y);

# ╔═╡ 4921db38-05cb-45d5-afdd-8f10a7aa12c0
begin
	plot(x_test, rand(MvNormal(m, Symmetric(C)), S * 10), color=:black, label="", alpha=0.1, ylims=(-2, 2))
	plot!(x_test, m, ribbon = sqrt.(diag(C)), color=:blue, fillalpha=0.2, label = "Prediction")
	plot!(x_test, sin.(x_test), color=:red, label="f")
	scatter!(X, y, color=:green, label = "Data")
end

# ╔═╡ b07bbb00-826a-47ec-827e-74f9981b0901
md"""
## 2. Gibbs sampler for outlier detection
"""

# ╔═╡ 1e2e3d6c-1b3a-4314-a9df-ebf29247741b
md"""
The file _outlier.dat_ on the web page of the course contains a data set $D = (y_1, \dots, y_N)$. Most of the observations have been drawn from a Gaussian probability distribution $\mathcal{N}(y_i; \mu,\sigma^2)$ with mean $\mu$ and variance $\sigma^2$. However, $D$ contains some **outliers**, which occur with probability $\epsilon$
and are displaced by a random offset $A_i$. For the purpose of **outlier detection** the model is augmented with an indicator variable
```math
\begin{align}
  \delta_i = \left\{
    \begin{array}{cl}
      1 & \textrm{if $y_i$ is an outlier,} \\
      0 & \textrm{if $y_i$ is a normal data point,}
    \end{array}
  \right.
\end{align}
```
for each observation. Assuming conjugate priors for the parameters yields the full stochastic model
```math
\begin{align}
  \begin{array}{cclcclccl}
    \mu &\sim& \mathcal{N}(\theta, v^2), &
    \sigma^{-2} &\sim& \mathrm{Gamma}(\kappa, \lambda), &
    \epsilon &\sim& \mathrm{Beta}(\alpha, \beta), \\
    y_i &\sim& \mathcal{N}(\mu + \delta_i \, A_i, \sigma^2), &
    \delta_i &\sim& \mathrm{Bernoulli}(\epsilon), &
    A_i &\sim& \mathcal{N}(0, \tau^2).
  \end{array}
\end{align}
```
We want to use a Gibbs sampler in order to draw samples from the posterior $p(\mu, \sigma^2, \epsilon, \boldsymbol{\delta}, \mathbf{A}| D)$ with $\boldsymbol{\delta} = (\delta_1, \dots, \delta_N)$ and $\mathbf{A} = (A_1, \dots, A_N)$. Some conditional posteriors are given by
```math
\begin{align}
  \mu \sim& \mathcal{N} \left( \frac{\sigma^2 \theta + v^2
      \sum_{i=1}^N (y_i - \delta_i \, A_i)}{\sigma^2 + N v^2},
    \frac{\sigma^2 v^2}{\sigma^2 + N v^2} \right), \\
  \sigma^{-2} \sim& \mathrm{Gamma} \left( \kappa + \frac{N}{2},
    \frac{2 \lambda}{2 + \lambda \sum_{i=1}^N (y_i - \delta_i \, A_i -
      \mu)^2} \right).
\end{align}
```
"""

# ╔═╡ 95a81d25-83dc-4be1-adb6-d6cab036b5d6
md"""
- ### [MATH] (a) Show that the remaining conditional posteriors are given by 

```math
\begin{align}
    \delta_i \sim& \mathrm{Bernoulli} \left( \frac{\epsilon}{\epsilon
        + (1 - \epsilon) \exp(-A_i (y_i - A_i - \mu) / (2 \sigma^2))}
    \right), \\
    A_i \sim& \mathcal{N} \left( \frac{\tau^2 \delta_i (y_i -
        \mu)}{\sigma^2 + \tau^2}, \frac{\sigma^2 \tau^2}{\sigma^2 +
        \tau^2 \delta_i} \right), \\
    \epsilon \sim& \mathrm{Beta} \left( \alpha + \sum_{i=1}^N
      \delta_i, \beta + \sum_{i=1}^N (1 - \delta_i) \right).
\end{align}
```
"""

# ╔═╡ e3e86464-ceb4-4d33-beb6-00ec6f288d83
md"""
#### Solution

- Joint probability distribution
```math  
\begin{align}
        p(\mu, \sigma^2, \epsilon, \boldsymbol{\delta}, \mathbf{A}, D)
        =& \frac{\Gamma(\alpha + \beta) \epsilon^{\alpha - 1} (1 -
          \epsilon)^{\beta - 1}}{\sqrt{2 \pi v^2} \Gamma(\kappa)
          \lambda^\kappa \Gamma(\alpha) \Gamma(\beta)}
        \sigma^{-2(\kappa - 1)}  e^{-\frac{\sigma^{-2}}{\lambda} -
          \frac{(\mu - \theta)^2}{2 v^2}} \\
        \times& \prod_{i=1}^N \frac{\epsilon^{\delta_i} (1 -
          \epsilon)^{1 - \delta_i}}{2 \pi \sigma \tau} e^{-\frac{(y_i
            - \delta_i \, A_i - \mu)^2}{2 \sigma^2} - \frac{A_i^2}{2
            \tau^2}}
\end{align}
```
"""

# ╔═╡ 99e01686-963c-4fc1-b79c-9086569abc94
md"""
- Conditional distributions

```math
\begin{align}
       p(\mu | \dots) \propto& e^{-\frac{(\mu - \theta)^2}{2 v^2} -
          \sum_{i=1}^N \frac{(y_i - \delta_i A_i - \mu)^2}{2
            \sigma^2}} \\
       \Rightarrow p(\mu | \dots) =&\mathcal{N}\left(\mu|\left(\frac{1}{\nu^2}+\frac{N}{\sigma^2}\right)^{-1}\left(\frac{\theta^2}{\nu^2}+\frac{1}{\sigma^2}\sum_i^Ny_i-\delta_iA_i)\right),\left(\frac{1}{\nu^2}+\frac{N}{\sigma^2}\right)^{-1}\right)\\
        p(\sigma^{-2} | \dots) \propto& \sigma^{-2(\kappa + N / 2 -
          1)} e^{-\sigma^{-2} \left( \frac{1}{\lambda} + \sum_{i=1}^N
            \frac{(y_i - \delta_i A_i - \mu)^2}{2} \right)}
        \\
        \Rightarrow p(\sigma^{-2} | \dots) = & \mathrm{Gamma} \left(\sigma^{-2}\mid \kappa + \frac{N}{2},
        \frac{2 \lambda}{2 + \lambda \sum_{i=1}^N (y_i - \delta_i \, A_i -
        	\mu)^2} \right).\\
        p(\delta_i | \dots) \propto& \epsilon^{\delta_i} (1 -
        \epsilon)^{1 - \delta_i} e^{-\delta_i \frac{A_i (A_i + \mu -
            y_i)}{2 \sigma^2}} \\
        \Rightarrow p(\delta_i\mid\dots)=&\mathrm{Bernoulli} \left( \frac{\epsilon}{\epsilon
        	+ (1 - \epsilon) \exp(-A_i (y_i - A_i - \mu) / (2 \sigma^2))}
        \right)\\
\end{align}
```
To get the new parameter of the Bernoulli distribution, compute the normalization constant by summing over $\delta_i=\{0,1\}$:
```math
\begin{align}
p(\delta_i=0)\propto &(1-\epsilon),\quad p(\delta_i=1)\propto \epsilon e^{-\frac{A_i(A_i+\mu-y_i)}{2\sigma^2}}\\ 
        \Rightarrow p(\delta_i=1)=&\frac{\epsilon e^{-\frac{A_i(A_i+\mu-y_i)}{2\sigma^2}}}{(1-\epsilon)+\epsilon e^{-\frac{A_i(A_i+\mu-y_i)}{2\sigma^2}}}=\frac{\epsilon }{(1-\epsilon)e^{\frac{A_i(A_i+\mu-y_i)}{2\sigma^2}}+\epsilon} \\
        p(A_i | \dots) \propto& e^{-\frac{(y_i - \delta_i \, A_i -
            \mu)^2}{2 \sigma^2} - \frac{A_i^2}{2 \tau^2}} \\
        \Rightarrow p(A_i|\dots) =& \mathcal{N} \left(A_i\mid \frac{\tau^2 \delta_i (y_i -
        	\mu)}{\sigma^2 + \tau^2}, \frac{\sigma^2 \tau^2}{\sigma^2 +
        	\tau^2 \delta_i} \right)\\
        p(\epsilon | \dots) \propto& \epsilon^{\alpha - 1 +
          \sum_{i=1}^N \delta_i} (1 - \epsilon)^{\beta - 1 +
          \sum_{i=1}^N (1 - \delta_i)}\\
      \Rightarrow p(\epsilon|\dots) =&\mathrm{Beta} \left(\epsilon\mid \alpha + \sum_{i=1}^N
      \delta_i, \beta + \sum_{i=1}^N (1 - \delta_i) \right).
\end{align}
```
"""

# ╔═╡ 30101030-d102-44db-a890-ab2bd44a890b
md"""
- ### (b) [CODE]  Write a program that implements the *Gibbs sampler*. Generate $10^3$ samples from the posterior using the hyperparameters $\theta = 0$, $v^2 = 100$, $\kappa = 2$, $\lambda = 2$, $\alpha =  2$, $\beta = 20$, $\tau^2 = 100$. Plot histograms showing the   marginal posteriors $p(\mu | D)$ and $p(\epsilon | D)$.
"""

# ╔═╡ d062ea12-ffc5-4d47-a6c5-2f760421b2d8
md"""
#### Solution
"""

# ╔═╡ eb8df563-f8d3-4115-9623-aee41084764a
function sample_μ(σ², θ, ν², y, δ, A, N)
    m = (σ² * θ  + ν² * sum(y - δ .* A)) / (σ² + N * ν²)
    c = σ² * ν² / (σ² + N * ν²)
    return rand(Normal(m, sqrt(c)))
end;

# ╔═╡ 840071a9-5b82-4a4d-a213-29b59f4edba0
function sample_σ²(κ, N, λ, y, δ, A, μ)
    a = κ + N / 2
    b = 2λ / (2 + λ * sum(abs2, y - δ .* A .- μ))
    return inv(rand(Gamma(a, b)))
end;

# ╔═╡ bda50468-72ef-4b74-9dbd-facfd0f4e013
function sample_δ(ϵ, A, y, μ, σ²)
    θ = ϵ ./ (ϵ .+ (1 - ϵ) * exp.(-A .* (y .- A .- μ) ./ (2σ²)))
    return rand.(Bernoulli.(θ))
end;

# ╔═╡ c3f0bc98-5052-4140-b8cb-745c2555faa0
function sample_A(τ², δ, y, μ, σ²)
    m = τ² * δ .* (y .- μ) / (σ² + τ²)
    c = σ² * τ² ./ (σ² .+ τ² .* δ)
    rand.(Normal.(m, sqrt.(c)))
end;

# ╔═╡ 8ee4652c-7d12-47bc-9ba3-12ac66a49a99
function sample_ϵ(α, δ, β)
   rand(Beta(α + sum(δ), β + sum(1 .- δ))) 
end;

# ╔═╡ 5da407c6-6512-481e-9be2-9f3901c5b815
begin # We load the data
	y_outlier = vec(readdlm("outlier.dat"))
	Ny = length(y_outlier)
end

# ╔═╡ 25abb01a-43b6-4e9d-ae4f-c61660656295
begin
	scatter(1:Ny, y_outlier; label="Data", legend=:bottomleft)
end

# ╔═╡ 78a94d5e-4f77-4af1-a962-95e48b89efb3
begin # We select multiple hyperparameters
	T = 10000
	θ = 0.0
	ν² = 100
	κ = 2
	λ = 2
	α = 2
	β = 20
	τ² = 100
end;

# ╔═╡ a589ea3b-27e3-4080-b25a-cef86b2f422e
begin
	# We initialize the random variables and preallocate storage
	A = randn(Ny); As = zeros(Ny, T)
	δ = rand(0:1, Ny); δs = zeros(Ny, T)
	ϵ = rand(); ϵs = zeros(T)
	σ² = rand(); σ²s = zeros(T)
	μ = randn(); μs = zeros(T)
	for i in 1:T
	    μ = sample_μ(σ², θ, ν², y_outlier, δ, A, Ny); μs[i] = μ
	    σ² = sample_σ²(κ, Ny, λ, y_outlier, δ, A, μ); σ²s[i] = σ²
	    δ = sample_δ(ϵ, A, y_outlier, μ, σ²); δs[:, i] = δ
	    A = sample_A(τ², δ, y_outlier, μ, σ²); As[:, i] = A
	    ϵ = sample_ϵ(α, δ, β); ϵs[i] = ϵ
	end
end

# ╔═╡ ab8b02e3-5306-4798-9810-c0acf08870ac
begin
	p1 = scatter(1:Ny, y_outlier, label = "y")
	p2 = histogram(μs, label = "μ", normalize = true, lw = 0.0)
	p3 = scatter(1:Ny, vec(mean(δs, dims = 2)), label = "δ")
	p4 = histogram(ϵs, label = "ϵ", normalize = true, lw = 0.0)
	plot(p1, p2, p3, p4, legendfontsize=6.0)
end

# ╔═╡ 82d85705-4579-48da-ac8b-e1d30ec06b97
md"""
### (c) Which data points in the file *outlier.dat* are outliers?   Use the samples generated in part (b) and the condition $p(\delta_i | D) \geq 0.02$ in order to identify them.
"""

# ╔═╡ 566ea32b-7642-4e28-81ff-8df7e4e14ad0
begin
	df = DataFrame([y_outlier[:], vec(mean(δs, dims = 2))], [:y, :pδ])
	df[df.pδ .>= 0.02, :]
end

# ╔═╡ Cell order:
# ╟─b9591cb5-81e4-4649-a524-0e8bbf92f35c
# ╠═2210245d-9790-4103-ac91-76caf3c175fb
# ╟─d0ca3350-6e7a-45b7-a535-25bf3818f89a
# ╟─52e4510d-352f-4cf2-bae5-fba2739fca5b
# ╟─d3ebc367-26e2-40ce-8845-056d48f7f759
# ╟─44f3ca60-88c4-4031-a1e6-19b5de86485f
# ╟─a13616ef-a5b3-464e-bb37-82fff7d906eb
# ╟─9dc81225-9793-425d-8644-3fd4b0300962
# ╠═6ef75a26-e3e4-4ca4-a145-835d3c897f48
# ╟─07c98d47-40b1-4e25-8fc0-d51279554c92
# ╟─e81cb189-63d8-45b9-8549-5596823369f8
# ╟─3c586e73-351b-4e73-a8dd-6dd2b618f80a
# ╟─d6a0df4f-22f2-4719-bd01-ac6cde1083b1
# ╟─6e64e61a-e52f-4246-945e-db7c2f5d1748
# ╟─b24e157a-c415-44a0-a5a2-d020d7bcb8f3
# ╠═1525a48a-01d3-4d3d-884f-69e9dbaddc91
# ╠═30fe2ca4-9c4e-45e9-9502-936ddf18d523
# ╠═bcefa4a9-04a6-4de8-91b2-170e5a309918
# ╠═4921db38-05cb-45d5-afdd-8f10a7aa12c0
# ╟─b07bbb00-826a-47ec-827e-74f9981b0901
# ╟─1e2e3d6c-1b3a-4314-a9df-ebf29247741b
# ╟─95a81d25-83dc-4be1-adb6-d6cab036b5d6
# ╟─e3e86464-ceb4-4d33-beb6-00ec6f288d83
# ╟─99e01686-963c-4fc1-b79c-9086569abc94
# ╟─30101030-d102-44db-a890-ab2bd44a890b
# ╟─d062ea12-ffc5-4d47-a6c5-2f760421b2d8
# ╠═eb8df563-f8d3-4115-9623-aee41084764a
# ╠═840071a9-5b82-4a4d-a213-29b59f4edba0
# ╠═bda50468-72ef-4b74-9dbd-facfd0f4e013
# ╠═c3f0bc98-5052-4140-b8cb-745c2555faa0
# ╠═8ee4652c-7d12-47bc-9ba3-12ac66a49a99
# ╠═5da407c6-6512-481e-9be2-9f3901c5b815
# ╟─25abb01a-43b6-4e9d-ae4f-c61660656295
# ╠═78a94d5e-4f77-4af1-a962-95e48b89efb3
# ╠═a589ea3b-27e3-4080-b25a-cef86b2f422e
# ╠═ab8b02e3-5306-4798-9810-c0acf08870ac
# ╟─82d85705-4579-48da-ac8b-e1d30ec06b97
# ╠═566ea32b-7642-4e28-81ff-8df7e4e14ad0
