### A Pluto.jl notebook ###
# v0.14.8

using Markdown
using InteractiveUtils

# ╔═╡ 23fcf153-fdb7-4222-929a-9ccca4000c56
begin
	using Pkg; Pkg.activate("."); Pkg.add(["Distributions", "Plots", "PyPlot", "PlutoUI"])
	using Distributions, LinearAlgebra
	using PlutoUI
	using Plots, StatsPlots; pyplot();
	default(lw = 3.0, legendfontsize= 15.0)
end

# ╔═╡ d4d860a4-e9c8-42d5-922a-db5c41b6ea2c
md"""
# Problem Sheet 5
"""

# ╔═╡ ae3e6062-389d-4c35-8798-86c93eb31532
TableOfContents()

# ╔═╡ 2560f763-8ca5-4215-ad05-3ea3b2a70c88
md"""
## 1. Variational inference
"""

# ╔═╡ a1f88514-056b-482a-b034-9dd5774e6673
md"""
Assume we have $n$ observations $D = (x_1,\ldots, x_n)$ generated independently from a Gaussian density 
${\cal{N}}(x | \mu, 1/\tau)$, i.e.
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
md"""*Fill in your answer here or on paper*"""

# ╔═╡ 1d502122-8c33-4326-a1da-ab4e42b83be0
md"""
### c) [CODE] From the generated dataset implement a coordinate ascent scheme, updating variational parameters of $\tau$ and $\mu$ in an alternated way.
"""

# ╔═╡ 253a0c99-0b89-42c3-a514-49d8ab763286
begin
	# We create some data
	N = 100
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
expec_μ(x, λ₀, μ₀, n) = ## FILL IN ## Return E_q[mu]

# ╔═╡ b00b68be-f456-4a50-9404-24b6408364cd
var_μ(e_τ, λ₀, n) =  ## FILL IN ## Return Var_q[mu]

# ╔═╡ 92eefc81-c4c1-4f84-877b-2903d827fa71
expec_τ(a, b) = a / b

# ╔═╡ d07b6f05-fd85-4c38-829f-6b771b4cb5b7
aₙ(a₀, n) = ## FILL IN ## Return first parameter of q(tau)

# ╔═╡ 636b809c-f6cc-4a88-943e-c538fd079961
bₙ(b₀, x, e_mu, var_mu, λ₀, μ₀) = ## FILL IN ## Return second parameter of q(tau)

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
        σ² =var_μ(e_τ, λ₀, N); σs[i] = σ²
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

# ╔═╡ Cell order:
# ╟─d4d860a4-e9c8-42d5-922a-db5c41b6ea2c
# ╠═23fcf153-fdb7-4222-929a-9ccca4000c56
# ╟─ae3e6062-389d-4c35-8798-86c93eb31532
# ╟─2560f763-8ca5-4215-ad05-3ea3b2a70c88
# ╟─a1f88514-056b-482a-b034-9dd5774e6673
# ╟─0a6c5acb-0ed7-45f7-8b37-1c691782f250
# ╟─e77abb95-e53e-43dc-8b42-0e50884652c9
# ╟─c7ab8bb4-e7b3-4fed-826e-f99d87dba2a4
# ╟─44376f8b-9049-4a57-bc17-f4726328e3d1
# ╟─1d502122-8c33-4326-a1da-ab4e42b83be0
# ╠═253a0c99-0b89-42c3-a514-49d8ab763286
# ╟─71a20efe-b2cd-422b-a41b-35b73f5a39e3
# ╠═3b93a1a0-244f-414e-ad7f-490cbab8b9b1
# ╠═b00b68be-f456-4a50-9404-24b6408364cd
# ╠═92eefc81-c4c1-4f84-877b-2903d827fa71
# ╠═d07b6f05-fd85-4c38-829f-6b771b4cb5b7
# ╠═636b809c-f6cc-4a88-943e-c538fd079961
# ╠═45f0c1e5-fbed-4441-89cf-2eaa8c63ede8
# ╠═41b97fde-b88e-4cc3-9f49-5800c1f0ad50
# ╠═bc67e83a-4ac9-43ea-bc11-bef055c7a26e
