### A Pluto.jl notebook ###
# v0.14.8

using Markdown
using InteractiveUtils

# ╔═╡ 80090c6b-973a-45ba-9aff-1c7e09747f6a
using Pkg; Pkg.activate("."); Pkg.add(["Distributions", "Plots", "PyPlot", "SpecialFunctions"])

# ╔═╡ 23fcf153-fdb7-4222-929a-9ccca4000c56
begin
	using Distributions
	using LinearAlgebra
	using Plots
	using StatsPlots
	pyplot()
	using SpecialFunctions
	default(lw = 3.0, legendfontsize= 15.0)
end

# ╔═╡ d4d860a4-e9c8-42d5-922a-db5c41b6ea2c
md"""
# Problem Sheet 5
"""

# ╔═╡ 2560f763-8ca5-4215-ad05-3ea3b2a70c88
md"""
## 1. Variational inference
"""

# ╔═╡ a1f88514-056b-482a-b034-9dd5774e6673
md"""
Assume we have $n$ observations $D = (x_1,\ldots, x_n)$ generated independently from a Gaussian density 
${\cal{N}}(x | \mu, \tau^{-1})$, i.e.
```math
p(D | \mu, \tau) = \left(\frac{\tau}{2\pi}\right)^{n/2} 
\exp\left[ - \frac{\tau}{2}  \sum_{i=1}^n (x_i - \mu)^2\right]
```
We also assume prior densities $p(\mu | \tau) = {\cal{N}}(\mu | \mu_0, (\lambda_0 \tau)^{-1})$ and
$p(\tau) = \mbox{Gamma}(\tau | a_0,b_0)$. $\lambda_0$ and $\mu_0$ as well as $a_0,b_0$ 
are given hyper parameters.

Our goal is to approximate the posterior density $p(\mu, \tau | D)$ by a  **factorising density**
$q(\mu,\tau) = q_1(\mu) q_2(\tau)$ which minimises the variational free energy 
```math
F[q] = \int q(\mu,\tau) \ln\frac{q(\mu,\tau)}{p(\mu,\tau,D)} \; d\mu\; d\tau
```

"""

# ╔═╡ 0a6c5acb-0ed7-45f7-8b37-1c691782f250
md"""
### (a) [MATH] Show that the optimal $q_1(\mu)$ is a _Gaussian density_ and give expressions for the mean and variance in terms of expectations with respect to $q_2$.
"""

# ╔═╡ e77abb95-e53e-43dc-8b42-0e50884652c9
md"""
### (b) [MATH] Show that the optimal $q_2(\tau)$ is a _Gamma density_ and give expressions for the parameters in terms of expectations with respect to $q_1$.
"""

# ╔═╡ c7ab8bb4-e7b3-4fed-826e-f99d87dba2a4
md"""

!!! tip
	You can use the following results which follow from the derivations given in the lecture
	```math
	\begin{align*}
	q_1(\mu) \propto \exp\left[ E_\tau \left[\ln p(\mu,\tau,D)\right]\right] \\
	q_2(\tau) \propto \exp\left[ E_\mu \left[\ln p(\mu,\tau,D)\right]\right]
	\end{align*}
	```
"""

# ╔═╡ 44376f8b-9049-4a57-bc17-f4726328e3d1
md"""
### Solution
We have the representation of the joint density
```math
p(\mu,\tau,D) = p(D |\mu,\tau) p(\mu | \tau) p(\tau)
```
with
```math
\begin{align*}
p(\mu | \tau)  = & \frac{(\lambda_0\tau)^{1/2}}{2\pi} \exp\left(- \frac{(\mu-\mu_0)^2 \lambda_0\tau}{2}\right) \\
p(\tau)  \propto  & \tau^{a_0 -1} e^{-b_o\tau}
\end{align*}
```
"""

# ╔═╡ c112fb73-1cf6-42fe-95fe-94c976f4e36f
md"""
#### a) 
Hence
```math
\begin{align*}
E_\tau \left[\ln p(\mu,\tau,D)\right] = - \frac{E_\tau[\tau]}{2} \sum_{i=1}^n(x_i-\mu)^2 - \frac{\lambda_0 E_\tau[\tau]}{2}
(\mu-\mu_0)^2 + \mbox{const}  = \\
-\frac{1}{2}\left(E_\tau[\tau] (n+ \lambda_0)\right) \mu^2 + \mu E_\tau[\tau] \left(\sum_i x_i + \lambda_0 \mu_0
\right)
+ \mbox{const}
\end{align*}
```
Note, that the second constant differs from the first.  We get a Gaussian density for $q_1(\mu)$ with
```math
\begin{align*} 
E[\mu] = \frac{\sum_i x_i + \lambda_0 \mu_0}{n+ \lambda_0} \\
\mbox{VAR}[\mu] = \frac{1}{E_\tau[\tau] (n+ \lambda_0)}
\end{align*}
```
"""

# ╔═╡ cd1bc19a-b793-499f-a4b2-8c56f99a3fc0
md"""
#### b)
for the density of $q_2(\tau)$, we use
```math
E_\tau \left[\ln p(\mu,\tau,D)\right] = \ln\left(\tau^{a_0+(n+1)/2 -1} e^{-b_0 \tau} \right) -
\frac{\tau}{2} \sum_{i=1}^n E_\mu[(x_i-\mu)^2] - \frac{\lambda_0 \tau}{2}
E_\mu[(\mu-\mu_0)^2] + \mbox{const}
```
We get a Gamma density 
```math
q_2(\tau) \propto \tau^{a_n -1} e^{-b_n \tau}
```
with parameters
```math
\begin{align*}
a_n  = & a_0+(n+1)/2 \\
b_n   = &  b_0 + \frac{1}{2} \sum_{i=1}^n E_\mu[(x_i-\mu)^2] + \frac{\lambda_0}{2}
E_\mu[(\mu-\mu_0)^2] 
\end{align*}
```
Knowing the form of both variational distributions we can also compute closed form solution of the expectations :
```math
\begin{align*}
E_\tau\left[\tau \right] = & \frac{a_n}{b_n}\\
E_\mu\left[(x-\mu)^2\right] = & \mathrm{Var}_\mu\left[\mu\right]+(x-E_\mu\left[\mu\right])^2
\end{align*}
```
And proceed to coordinate ascent updates to converge to the optimal distribution.
"""

# ╔═╡ 1d502122-8c33-4326-a1da-ab4e42b83be0
md"""
### c) [CODE] From the generated dataset implement a coordinate ascent scheme, updating variational parameters of $\tau$ and $\mu$ in an alternated way.
"""

# ╔═╡ 253a0c99-0b89-42c3-a514-49d8ab763286
begin
	N = 50
	μ₀ = 5.0
	λ₀ = 2.0
	a₀ = 1.0
	b₀ = 2.0
	τ = rand(Gamma(a₀, b₀))
	μ = rand(Normal(μ₀, inv(sqrt(τ * λ₀))))
	x = rand(Normal(μ, inv(sqrt(τ))), N)
end;

# ╔═╡ 71a20efe-b2cd-422b-a41b-35b73f5a39e3
histogram(x, lab="", bins=20, lw=0.1)

# ╔═╡ 3b93a1a0-244f-414e-ad7f-490cbab8b9b1
begin
	expec_μ(x, λ₀, μ₀, n) = (sum(x) + λ₀ * μ₀) / (n + λ₀)
	var_μ(e_τ, λ₀, n) = inv(e_τ * (n + λ₀))
	expec_τ(a, b) = a / b
	shifted_expec(e_mu, var_mu, x) = var_mu + abs2(x - e_mu)
	aₙ(a₀, n) = a₀ + (n + 1)/2
	bₙ(b₀, x, e_mu, var_mu, λ₀, μ₀) = b₀ + 0.5 * (sum(shifted_expec.(e_mu, var_mu, x)) + λ₀ * shifted_expec(e_mu, var_mu, μ₀))
end

# ╔═╡ 45f0c1e5-fbed-4441-89cf-2eaa8c63ede8
function coordinate_ascent(T, a = 1.0, b = 1.0, μ = 1.0, σ² = 1.0)
    as = vcat(a, zeros(T))
    bs = vcat(b, zeros(T))
    μs = vcat(μ, zeros(T))
    σs = vcat(σ², zeros(T))
    for i in 2:T+1
        a = aₙ(a₀, N); as[i] = a;
        b = bₙ(b₀, x, μ, σ², λ₀, μ₀); bs[i] = b
        e_τ = expec_τ(a, b)
        μ = expec_μ(x, λ₀, μ₀, N); μs[i] = μ
        σ² = var_μ(e_τ, λ₀, N); σs[i] = σ²
    end
    return as, bs, μs, σs
end

# ╔═╡ 41b97fde-b88e-4cc3-9f49-5800c1f0ad50
begin
	T = 20
	as, bs, mus, σs = coordinate_ascent(T)
	plt1 = plot([as bs], label = ["a" "b"])
	plt2 = plot([mus σs], label = ["μ" "σ²"])
	plot(plt1, plt2)
end

# ╔═╡ bc67e83a-4ac9-43ea-bc11-bef055c7a26e
begin
	T_hard = 20
	as_hard, bs_hard, mus_hard, σs_hard = coordinate_ascent(T_hard, 1000, 2000, 300, 1e3)
	p1 = plot([as_hard bs_hard], label = ["a" "b"], yaxis = :log)
	p2 = plot([mus_hard σs_hard], label = ["μ" "σ²"], yaxis = :log)
	plot(p1, p2)
end

# ╔═╡ 21a09e77-6510-4312-a932-44e444c13890
struct NormalGamma{T}
	μ::T
	λ::T
	shape::T
	rate::T
end

# ╔═╡ eb1de851-767e-418e-9b62-6399b7ea6003
function Distributions.logpdf(d::NormalGamma, x::Real, τ::Real)
	C = d.shape * log(d.rate) - lgamma(d.shape) + 0.5 * (log(d.λ) - log(2π))
	return C + (d.shape - 0.5) * log(τ) - 0.5 * τ * (d.λ * (x - d.μ)^2 + 2 * d.rate)
end

# ╔═╡ 396a050b-8c05-450f-b746-5e6e323d22a5
struct VariationalDistribution{T1,T2}
	q1::T1
	q2::T2
end

# ╔═╡ fde6d3c5-459d-4e76-b5b2-a7a9861afc24
function Distributions.logpdf(d::VariationalDistribution, x::Real, τ::Real)
	return logpdf(d.q1, x) + logpdf(d.q2, τ)
end

# ╔═╡ 7c15ddea-5a36-48a8-8f3a-8d362067a1e2
opt_posterior = NormalGamma(
	(λ₀ * μ₀ + N * mean(x)) / (λ₀ + N),
	λ₀ + N,
	a₀ + N / 2,
	b₀ + 0.5 * (N * var(x) + (λ₀ * N * (mean(x) - μ₀)^2) / (λ₀ + N))
)

# ╔═╡ 1a63b0ad-f42c-4637-b5d6-cccf6a891201
xrange = range(μ - 1, μ + 1, length=100)

# ╔═╡ 2107ef0e-778c-4a18-96bc-ef72302c6ece
yrange = range(max(τ - 3, 0), τ + 3, length=100)

# ╔═╡ 1744d121-620f-4224-8c16-bc67a6a1ee9b
begin
	contourf(xrange, yrange, (x,y)->exp(logpdf(opt_posterior, x, y)), title="True posterior", 
xlabel="μ", ylabel="τ")
	scatter!([μ], [τ], lab="")
end

# ╔═╡ 775bc0e5-586d-4ba6-ae0e-8e37b89b6dd3
opt_variational = VariationalDistribution(
	Normal(mus[end], sqrt(σs[end])),
	Gamma(as[end], 1 / bs[end])
)

# ╔═╡ 63a1b0a4-b856-4f8b-8fb1-bfc49c437bd7
begin
	contourf(xrange, yrange, (x,y)->exp(logpdf(opt_variational, x, y)), title="Variational Distribution", xlabel="μ", ylabel="τ")
	scatter!([μ], [τ], lab="")
end

# ╔═╡ Cell order:
# ╟─d4d860a4-e9c8-42d5-922a-db5c41b6ea2c
# ╠═80090c6b-973a-45ba-9aff-1c7e09747f6a
# ╠═23fcf153-fdb7-4222-929a-9ccca4000c56
# ╟─2560f763-8ca5-4215-ad05-3ea3b2a70c88
# ╟─a1f88514-056b-482a-b034-9dd5774e6673
# ╟─0a6c5acb-0ed7-45f7-8b37-1c691782f250
# ╟─e77abb95-e53e-43dc-8b42-0e50884652c9
# ╟─c7ab8bb4-e7b3-4fed-826e-f99d87dba2a4
# ╟─44376f8b-9049-4a57-bc17-f4726328e3d1
# ╟─c112fb73-1cf6-42fe-95fe-94c976f4e36f
# ╟─cd1bc19a-b793-499f-a4b2-8c56f99a3fc0
# ╟─1d502122-8c33-4326-a1da-ab4e42b83be0
# ╠═253a0c99-0b89-42c3-a514-49d8ab763286
# ╠═71a20efe-b2cd-422b-a41b-35b73f5a39e3
# ╠═3b93a1a0-244f-414e-ad7f-490cbab8b9b1
# ╠═45f0c1e5-fbed-4441-89cf-2eaa8c63ede8
# ╠═41b97fde-b88e-4cc3-9f49-5800c1f0ad50
# ╠═bc67e83a-4ac9-43ea-bc11-bef055c7a26e
# ╠═21a09e77-6510-4312-a932-44e444c13890
# ╠═eb1de851-767e-418e-9b62-6399b7ea6003
# ╠═396a050b-8c05-450f-b746-5e6e323d22a5
# ╠═fde6d3c5-459d-4e76-b5b2-a7a9861afc24
# ╠═7c15ddea-5a36-48a8-8f3a-8d362067a1e2
# ╟─1a63b0ad-f42c-4637-b5d6-cccf6a891201
# ╟─2107ef0e-778c-4a18-96bc-ef72302c6ece
# ╠═1744d121-620f-4224-8c16-bc67a6a1ee9b
# ╠═775bc0e5-586d-4ba6-ae0e-8e37b89b6dd3
# ╠═63a1b0a4-b856-4f8b-8fb1-bfc49c437bd7
