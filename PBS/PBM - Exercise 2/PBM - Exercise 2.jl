### A Pluto.jl notebook ###
# v0.14.4

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

# ╔═╡ a9511140-81af-40ef-ab08-cebf4b9d72af
begin
	using Pkg; Pkg.add(["Distributions", "LinearAlgebra", "Plots", "PlutoUI"])
	using Distributions
	using LinearAlgebra
	using Plots
	using PlutoUI
	default(;linewidth=3.0, legendfontsize=15.0)
end

# ╔═╡ e7d75573-b510-498e-9f98-e159039b0297
md"""
# Problem Sheet 2
"""

# ╔═╡ dd7f5a83-8b2d-4d64-8f3a-17ecc501009c
TableOfContents()

# ╔═╡ 8694efff-b0d7-47ec-8ab9-a136cb0ada83
md"""
## 1. EM algorithm for a Poisson mixture model
"""

# ╔═╡ 60cf7b1a-3e05-4f47-a7a5-6cc1112c95be
md"""
Consider a mixture model for a integer valued random variable $n \in
\{0, 1, 2, \dots\}$ given by the distribution
```math
\begin{align}
  P(n | \boldsymbol\theta) = \sum_{j=1}^M P(j) \; P(n | \theta_j) =
  \sum_{j=1}^M P(j) \; e^{-\theta_j} \frac{\theta_j^n}{n!} \,,
\end{align}
```
where the component probabilities $P(n | \theta_j)$ are Poisson
distributions. Based on a data set of i.i.d.~samples $D = (n_1, n_2,
\dots, n_N)$ we want to estimate the parameters $\boldsymbol\theta =
(\theta_1, \dots, \theta_M, P(1), \dots, P(M))$ of this mixture model.
"""

# ╔═╡ 28eca8bb-b7bb-48c7-a719-f59950216adc
md"""
### (a) [MATH] Derive an expression for the **Maximum Likelihood** estimate   of $\theta_1$ for $M = 1$, where all obervations come from the same   Poisson distribution.
"""

# ╔═╡ fab08b49-8fc1-4fe3-a837-fe184be6026e
md"""
### (b) [MATH] For $M > 1$ the maximum likelihood estimates of the parameters are to be determined using an EM algorithm. Give explicit formulas for the update of $\theta_j$ and $P(j)$.

**Hint:** For the E-step (see the lecture), compute
```math
\begin{align}
    \mathcal{L}(\boldsymbol\theta, \boldsymbol\theta_t) =
    -\sum_{i=1}^N \sum_{j=1}^M P_t(j | n_i, \theta_t) \ln \left( P(n_i |
      \theta_j) \, P(j) \right),
\end{align}
```
where $P_t(j|n_i)$ is the responsibility of component $j$ for generating data point $n_i$, computed with the current values of the parameters. For the M-step, minimise $\mathcal{L}$ with respect to $\theta_j$ and $P(j)$.
"""

# ╔═╡ 771b0f5e-8b63-4560-bc31-032224153a20
md"""
### (c) [CODE] Create a toy dataset with $N=1000$ samples from a mixture of Poisson with $M = 3$, $\theta_1 = 1.0, \theta_2 = 20.0, \theta_3 = 50.0$ and $P(1)=P(2)=P(3)=1/3$. Implement you EM algorithm to recover these parameters
"""

# ╔═╡ 040f78ac-a7ad-481a-b1ae-7fae19b3e414
function mixpoisson(θ, p) # Return a mixture of Poissons with parameters theta and weights p
    MixtureModel(Poisson.(θ), p)
end

# ╔═╡ aa1be54b-3b72-4f43-aae5-8abc4af12eb3
θ_true =  [1.0, 20.0, 50.0]; # Poisson parameters

# ╔═╡ 6c412cfe-6831-4cf5-aa2d-745b6d2b895c
p_true =  [1/3, 1/3, 1/3]; # Mixture parameters

# ╔═╡ 6d70d73d-478d-4017-a7f4-d47c5d4cc389
d = mixpoisson(θ_true, p_true); # The true Poisson mixture

# ╔═╡ 737fc846-c923-4400-96c5-7103310ba52c
N = 1000; # Number of samples

# ╔═╡ 59025637-02ae-4ddd-b35c-5b2ea7676666
n = rand(d, N); # Sampled data

# ╔═╡ b6d3505d-15dc-4323-b945-4e8b650b46b1
begin
	histogram(n, nbins=20, normalize = true, lw = 1.0, lab = "Samples")
	plot!(0:1:80, x->pdf(d, x), label = "p(n)")
end

# ╔═╡ 4198d26d-d660-48d9-9520-e818f3c84b2a
function pt(θ, p, n) # Compute Pt(p | θ, n)
	## !! CODE MISSING !! ##
	## Compute here the value of Pt(p | θ, n) for one observation n
	## !! CODE MISSING !! ##
end;

# ╔═╡ 4e6759fe-59b7-4b85-9316-9960acd5b6e2
function update!(θ, p, n) # Update the parameters
    M = length(p)
    N = length(n)
    pvals = zeros(N, M) # Preallocate the values of pt
    θvals = zeros(N, M) # Preallocate the tmp values for θ
    for i in 1:N # Loop over all the points
        x = pt(θ, p, n[i]) # Compute Pt for each j (x is a vector)
        pvals[i, :] = x # Save Pt value
        θvals[i, :] = n[i] * x # Compute n * Pt
    end
    p .= nothing ## !!CODE MISSING!! Update p given pvals and θvals
    θ .= nothing ## !!CODE MISSING!! Update θ given pvals and θvals
end;

# ╔═╡ 27a052f4-c735-401b-ae31-af9af0259e41
md"""
Number of components
M = $(@bind M Slider(1:15, default=3, show_value=true))
"""

# ╔═╡ d2ffe6d5-acb4-4151-838a-fb798ba418f5
begin
	if pt(0, 0, 0) !== nothing
		nIter = 10 # Number of iterations
		θ = rand(M) * 50 # Random initialization of the pararameters
		p = rand(M); p /= sum(p) # Random initialization of the weights and normalization
		anim = Animation() # Create an animation
		anim = @animate for i in 1:nIter # Run the algorithm for a few iterations
			d = mixpoisson(θ, p)
			histogram(n, nbins=20, normalize = true, lab = "", lw = 1.0)
			plot!(0:1:80,x->pdf(d, x), lab = "p(n)", title = "i = $(i)")
			update!(θ, p, n)
		end
		gif(anim, fps = 3)
	end
end

# ╔═╡ 5481ce67-e92a-47ac-b3d2-07a30bf25b37
begin
	if @isdefined(θ)
		scatter(θ, p, xlabel="θ", ylabel="p", title="Component weight vs parameter", label="Inferred", legend=:bottomright)
		scatter!(θ_true, p_true, label="True parameters")
	end
end

# ╔═╡ 9a498362-d89d-4618-9aaa-a7d5aa12efc3
md"""
## 2. Bayesian estimation for the Poisson distribution
"""

# ╔═╡ e2285230-c59a-4c0d-a6da-fd1ee7b25ebc
md"""
Consider again the Poisson distribution for an integer valued random variable $n \in
\{0, 1, 2, \dots\}$ 
\begin{align}
  P(n | \theta) = e^{-\theta} \frac{\theta^n}{n!} \,,
\end{align}
"""

# ╔═╡ 04ff3e26-aec7-4be3-9ea9-199ca5a54063
md"""
- ### [MATH] (a) Write the Poisson distribution in the **exponential family** form :

\begin{align}
P(n | \theta) = f(n) \exp\left[\psi(\theta) \phi(n) + g(\theta)\right]
\end{align}
"""

# ╔═╡ 3aa2cff8-73e6-4cd0-89e1-f96b822757eb
md"""
- ### (b) [MATH] Use this exponential family representation to show that the **conjugate prior** for the Poisson distribution is given by the **Gamma density**

\begin{align}
p(\theta |\alpha,\beta) = \frac{\beta^\alpha}{\Gamma(\alpha)} \theta^{\alpha -1} e^{-\beta\theta}
\end{align}

### where $\alpha,\beta$ are hyperparameters.
"""

# ╔═╡ 49156838-6344-4b49-8773-d556f85ae1a0
md"""##### Gamma distribution visualization"""

# ╔═╡ 7bba63ba-4842-4bb4-a1d2-97f43c45699e
md"""α\_gamma = $(@bind α_gamma Slider(0.1:0.1:10; default=1, show_value=true))

β\_gamma = $(@bind β_gamma Slider(0.1:0.1:10; default=1, show_value=true))"""

# ╔═╡ 0f1ec051-fa5b-4838-b03c-ce5612a2baa3
plot(0:0.01:20,x->pdf(Gamma(α_gamma, β_gamma), x), xlabel="θ", ylabel="p(θ)", label="PDF of Gamma")

# ╔═╡ 7d9b779f-5a2c-4f53-8dd5-4b72eeb96e24
md"""
- ### (c) [MATH] Assume that we observe Poisson data $D= (n_1,n_2,\ldots,n_N)$. Write down the posterior distribution $p(\theta | D)$ assuming the __Gamma__ prior. What are the __posterior mean__  and __MAP estimators__ for $\theta$ ?
"""

# ╔═╡ e87b644a-b33b-4fb9-b28b-c4d29a7b2570
md"""
- ### (d) [MATH] Compute the __posterior variance__ for large $N$ and compare your result with the asymptotic frequentist error of the maximum likelihood estimator. 
!!! tip
	For the computation of the frequentist error use the __Fisher Information__ $J(\theta) \doteq E[(\frac{d\ln P(n |\theta)}{d\theta})^2]$ where the expectation is over the probability distribution $P(n |\theta)$.
"""

# ╔═╡ 5f4051c4-2a37-4a12-9191-27c6269473b1
md"""
- ### (e) [CODE] Estimate the posterior distribution by continuously sampling from a Poisson distribution and compare with the Maximum likelihood estimator.
"""

# ╔═╡ 9703763a-693c-4c2e-822e-1b88ba99620f
md"""θ\_🐟= $(@bind θ_poisson Slider(0.1:0.1:20; default=10.0, show_value=true)) : True Poisson parameter"""

# ╔═╡ 7fe119d8-ff6c-4fb3-bb54-9b6131dedf4b
d_poisson = Poisson(θ_poisson); # True Poisson distribution

# ╔═╡ c2c25d2a-7b43-4bf5-a84b-4fd636f95f41
alpha(n, α) = nothing # ## !! CODE MISSING !! give here the posterior parameter alpha

# ╔═╡ 9bd49414-5271-48a6-a289-b327892e13d3
beta(N, β) = nothing # ## !! CODE MISSING !! give here the posterior parameter beta

# ╔═╡ 49981e65-9c53-4aee-8c3c-25054ef3a0a5
mapestimator(n, α, β) = nothing # ## !! CODE MISSING !! compute the MAP estimator of θ

# ╔═╡ 5e37f6ca-0573-4edf-806a-6f7ec6e65fc8
mlestimator(n) = nothing # ## !! CODE MISSING !! compute the Maximum Likelihood estimator of θ

# ╔═╡ ea9a7988-c5e1-4217-95c8-ea439f0fb04a
md"""α = $(@bind α Slider(0.1:0.1:5; default=2.0, show_value=true))

β = $(@bind β Slider(0.1:0.1:5; default=3.0, show_value=true))"""

# ╔═╡ 310f5358-51bb-4467-8ba4-3a431479b012
d_prior = Gamma(α, 1/β); # Prior distribution

# ╔═╡ 249fee6c-5917-4380-81c4-ce141ac7ba30
begin # Elements for plotting
	nrange = 0:1:30
	xrange = 0:0.01:30
	Nmax = 50
	n_samples_per_step = 10
end;

# ╔═╡ c11d4701-4b5f-4eb3-b1ff-f45b18052f00
begin
	n_model = Int[]
	anim_2 = @animate for i in 1:Nmax
		for _ in 1:n_samples_per_step
			push!(n_model, rand(d_poisson)) # Add n new samples
		end
		p1 = histogram(n_model; nbins=length(nrange), normalize=true, linewidth=0.0, title="N = $(i *  n_samples_per_step)", label="")
		plot!(nrange, x -> pdf(d_poisson, x), label="p(D)", ylims=(0, 0.35))
		d_posterior = Gamma(alpha(n_model, α),  1 / beta(length(n_model), β)) # Distributions.jl uses a different parametrization
		p2 = plot(xrange, x -> pdf(d_posterior, x), label="p(θ|D)")
		plot!(xrange, x -> pdf(d_prior, x); label="p(θ)")
		vline!([mapestimator(n_model, α, β)]; label="MAP", ylims=(0, 1.4))
		vline!([mlestimator(n_model)]; label="ML")
		vline!([θ_poisson]; label="θ_poisson")
		plot(p1, p2; size=(800, 300))
	end
end;

# ╔═╡ 81740066-c972-4d29-b40d-4c37c445fbcb
gif(anim_2, fps = 5)

# ╔═╡ 1029519f-a783-4c95-87fa-12c1caa8d681
function fill_in()
	return md"""*Fill in your answer here or on paper*"""
end

# ╔═╡ bcb25dd7-b470-4d21-a845-6312745bd6ad
fill_in()

# ╔═╡ 578f6e5a-bbd0-4d52-9280-63d8ffb2816e
fill_in()

# ╔═╡ f5b9e935-7933-4149-a6ec-ccd8198e5dba
fill_in()

# ╔═╡ 9f5ead77-5c6e-48a0-bb97-860ba197e49d
fill_in()

# ╔═╡ 528602b9-b629-42df-b761-2ae60e5d5952
fill_in()

# ╔═╡ 7e002841-67b1-4fd8-a9a8-20b91743ca9d
fill_in()

# ╔═╡ Cell order:
# ╟─e7d75573-b510-498e-9f98-e159039b0297
# ╠═a9511140-81af-40ef-ab08-cebf4b9d72af
# ╟─dd7f5a83-8b2d-4d64-8f3a-17ecc501009c
# ╟─8694efff-b0d7-47ec-8ab9-a136cb0ada83
# ╟─60cf7b1a-3e05-4f47-a7a5-6cc1112c95be
# ╟─28eca8bb-b7bb-48c7-a719-f59950216adc
# ╟─bcb25dd7-b470-4d21-a845-6312745bd6ad
# ╟─fab08b49-8fc1-4fe3-a837-fe184be6026e
# ╟─578f6e5a-bbd0-4d52-9280-63d8ffb2816e
# ╟─771b0f5e-8b63-4560-bc31-032224153a20
# ╠═040f78ac-a7ad-481a-b1ae-7fae19b3e414
# ╠═aa1be54b-3b72-4f43-aae5-8abc4af12eb3
# ╠═6c412cfe-6831-4cf5-aa2d-745b6d2b895c
# ╠═6d70d73d-478d-4017-a7f4-d47c5d4cc389
# ╠═737fc846-c923-4400-96c5-7103310ba52c
# ╠═59025637-02ae-4ddd-b35c-5b2ea7676666
# ╟─b6d3505d-15dc-4323-b945-4e8b650b46b1
# ╠═4198d26d-d660-48d9-9520-e818f3c84b2a
# ╠═4e6759fe-59b7-4b85-9316-9960acd5b6e2
# ╟─27a052f4-c735-401b-ae31-af9af0259e41
# ╠═d2ffe6d5-acb4-4151-838a-fb798ba418f5
# ╟─5481ce67-e92a-47ac-b3d2-07a30bf25b37
# ╟─9a498362-d89d-4618-9aaa-a7d5aa12efc3
# ╟─e2285230-c59a-4c0d-a6da-fd1ee7b25ebc
# ╟─04ff3e26-aec7-4be3-9ea9-199ca5a54063
# ╟─f5b9e935-7933-4149-a6ec-ccd8198e5dba
# ╟─3aa2cff8-73e6-4cd0-89e1-f96b822757eb
# ╠═9f5ead77-5c6e-48a0-bb97-860ba197e49d
# ╟─49156838-6344-4b49-8773-d556f85ae1a0
# ╟─7bba63ba-4842-4bb4-a1d2-97f43c45699e
# ╟─0f1ec051-fa5b-4838-b03c-ce5612a2baa3
# ╟─7d9b779f-5a2c-4f53-8dd5-4b72eeb96e24
# ╟─528602b9-b629-42df-b761-2ae60e5d5952
# ╟─e87b644a-b33b-4fb9-b28b-c4d29a7b2570
# ╟─7e002841-67b1-4fd8-a9a8-20b91743ca9d
# ╟─5f4051c4-2a37-4a12-9191-27c6269473b1
# ╟─9703763a-693c-4c2e-822e-1b88ba99620f
# ╠═7fe119d8-ff6c-4fb3-bb54-9b6131dedf4b
# ╠═c2c25d2a-7b43-4bf5-a84b-4fd636f95f41
# ╠═9bd49414-5271-48a6-a289-b327892e13d3
# ╠═49981e65-9c53-4aee-8c3c-25054ef3a0a5
# ╠═5e37f6ca-0573-4edf-806a-6f7ec6e65fc8
# ╟─ea9a7988-c5e1-4217-95c8-ea439f0fb04a
# ╠═310f5358-51bb-4467-8ba4-3a431479b012
# ╠═249fee6c-5917-4380-81c4-ce141ac7ba30
# ╠═c11d4701-4b5f-4eb3-b1ff-f45b18052f00
# ╠═81740066-c972-4d29-b40d-4c37c445fbcb
# ╟─1029519f-a783-4c95-87fa-12c1caa8d681
