### A Pluto.jl notebook ###
# v0.14.5

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

# ╔═╡ 6014322e-bd4a-4cf3-8ac3-0d528b9d4b59
begin
	using Pkg
	Pkg.activate(".")
	Pkg.add(["Distributions", "Plots", "PlutoUI"])
	using Distributions
	using LinearAlgebra
	using Plots
	using PlutoUI
	default(linewidth = 3.0, legendfontsize= 15.0)
end

# ╔═╡ aff9e39c-f80a-4bab-a3c3-89520ce7bf16
md"""
# Problem Sheet 3
"""

# ╔═╡ 33885d8f-4c8a-47de-9d3b-62ac35916a77
TableOfContents()

# ╔═╡ d3f9b7b9-6ff0-48ef-875b-ec02871d4e43
md"""
## 1. Bayes inference for the variance of a Gaussian
"""

# ╔═╡ a17a1352-be6c-4df9-8b60-b9eb646cee10
md"""
Use a Bayesian approach to estimate the inverse variance $\lambda$ of
a univariate Gaussian distribution
```math
\begin{align*}
p(x | \lambda) = \sqrt{\frac{\lambda}{2 \pi}} \; \exp \left[
-\frac{\lambda x^2}{2} \right].
\end{align*}
```
Here we have assumed for simplicity that the data has zero mean
$\mu=0$. To apply Bayesian inference we specify a **Gamma** prior
distribution for $\lambda$,
```math
\begin{align*}
p(\lambda) = \frac{\lambda^{\alpha - 1} \exp \left[ -\lambda / \beta
	\right]}{\Gamma(\alpha) \beta^\alpha}
\end{align*}
```
where the positive numbers $\alpha$ and $\beta$, the
\emph{hyperparameters} of the model are assumed to be known and
$\Gamma(\alpha)$ is Euler's **gamma** function. We then observe a dataset $D = (x_1, x_2, \ldots, x_N)$
comprising $N$ independent random samples from $p(x | \lambda)$.
"""

# ╔═╡ c55fcb2c-e738-4dae-a63d-e5d8f3243999
md"""
### (a) [MATH]  Show that the posterior probability $p(\lambda | D)$ of the inverse variance is also a Gamma distribution with parameters

```math
\begin{align}
	\alpha_{p} = \alpha + \frac{N}{2}, \qquad \frac{1}{\beta_{p}} =
	\frac{1}{\beta} + \frac{1}{2} \sum_{i = 1}^N x_i^2.
\end{align}
```
"""

# ╔═╡ 488e44f2-140d-4ec5-a6a9-a0da44ef2789
md"""
### (b) [MATH] Compute the mean of the posterior distribution of $\lambda$. Compare the result with the result from the maximum-likelihood estimation, $\lambda_\mathrm{ML} = 1 /\sigma_\mathrm{ML}^2$ and explain what happens if $N \rightarrow \infty$.
"""

# ╔═╡ ec62a4b1-b5db-4c68-a4a3-3d70d2608bc9
md"""
### (c) [MATH] Show that the variance of the posterior distribution 

\begin{align}
	V[\lambda_\mathrm{post}] = \langle \lambda^2 \rangle - \langle
	\lambda \rangle^2
\end{align}

### shrinks to zero as $N \rightarrow \infty$. Here we have used the notation $\langle \cdot \rangle$ for posterior expectations.
"""

# ╔═╡ 5e5a551b-8575-4981-ae2e-7947db88660e
md"""
### (d) [MATH] Show that the predictive distribution is

```math
\begin{align}
	p(x | D) = \frac{1}{\sqrt{2 \pi}} \frac{\Gamma(\alpha_p + 1 /
		2)}{\Gamma(\alpha_p)} \sqrt{\beta_p} \left(1 + \frac{x^2
		\beta_p}{2} \right)^{-\alpha_p - 1 / 2}
\end{align}
```
### where $\alpha_p$ and $\beta_p$ were defined above. Note, this is not a Gaussian!
"""

# ╔═╡ 065ecdf2-a172-4bfa-a5c9-53263af11232
md"""
### (e) [CODE] Program a function generating samples from a known value $\lambda$ and compute both the posterior distribution and ML estimator by adding progressively new samples.
"""

# ╔═╡ 4bc2828b-155f-49f9-b0c3-95b90dd05d9a
gamma_params = (α=2.0, β=0.5);

# ╔═╡ b23659fc-774b-4c98-9a93-498e538bd45b
true_λ = rand(Gamma(gamma_params...)) # We sample a random value λ

# ╔═╡ f3f9d85a-d5c0-4e01-a54f-dcf08872650d
generate_x(λ) = ## !! FILL IN !! Generate a random value x from a give λ

# ╔═╡ d1e8e03f-2185-4832-906c-97f29c0a99ce
αp(x, α) = ## !! FILL IN !! Return the posterior alpha paramter

# ╔═╡ e538341a-b015-4f2b-84fa-9f9cbc5f4f42
βp(x, β) = ## !! FILL IN !! Return the posterior beta paramter

# ╔═╡ be22cc8d-d3f2-4254-88f1-b4da7610a485
posterior_λ(x, α, β) = Gamma(αp(x, α), βp(x, β)); # Posterior distribution

# ╔═╡ 2a5c42f6-3b3d-4f0b-baa7-e41ecba20e07
λ_ML(x) = ## !! FILL IN !! Return the maximum likelihood estimator

# ╔═╡ a6dad265-2bc4-47b1-8ff5-44ccefdca76f
begin  # Plotting values
	N = 10000
	bins = range(-5, 5, length = 50)
	range_λ = range(0, 5.0, length = 300)
end

# ╔═╡ 3ef9ea88-6d93-4615-8d2e-b3c03fa4cebc
begin
	xs = Float64[]
	anim = Animation()
	for i in 1:N
		push!(xs, generate_x(true_λ))
		if i % 10^floor(Int64, log10(i)) == 0
			p_x = histogram(xs, bins = bins, lw = 0.0, label = "", title = "N = $i")
			p_λ = plot(range_λ, x -> pdf(posterior_λ(xs, gamma_params...), x), label = "p(λ|D)")
			vline!([λ_ML(xs)], label = "λ ML")
			vline!([true_λ], label = "true λ")
			plot(p_x, p_λ, size = (800,400))
			frame(anim)
		end
	end
end

# ╔═╡ 2a42c84f-ad7b-4a99-9a17-56ad2530cf75
gif(anim, fps = 6)

# ╔═╡ 34705486-aa02-40eb-b1b6-432d25708e36
posterior_λ(xs, gamma_params...)

# ╔═╡ 59e60a2c-cf16-4055-80ab-b3b30651e5ff
md"""
## 2. Hyperparameter estimation for a generalised linear model
"""

# ╔═╡ ece15487-f139-4952-a75b-c964ae06beb9
md"""
Consider a model for a set of data $D=(y_1, \dots, y_n)$ defined by
```math
\begin{align}
  p(D | \mathbf{w}, \beta) = \left( \frac{\beta}{2 \pi} \right)^{N /
    2} \exp \left[ -\sum_{i=1}^N \frac{\beta}{2} \left( y_i -
      \sum_{j=1}^K w_j \Phi_j(x_i) \right)^2 \right]
\end{align}
```
with a fixed set $\{ \Phi_1(x), \dots, \Phi_k(x) \}$ of $K$ basis functions. The prior distribution on the weights is given by
```math
\begin{align}
  p(\mathbf{w} | \alpha) = \left( \frac{\alpha}{2 \pi} \right)^{K / 2}
  \exp \left[ -\frac{\alpha}{2} \sum_{j=1}^K w_j^2 \right].
\end{align}
```
This **generalised linear model** assumes that the observations are
generated from a weighted linear combination of the basis functions
with additive Gaussian noise.
"""

# ╔═╡ 0344ce71-c040-4a0b-8ae2-6bbf49aa272e
md"""
- ### (a) [MATH] The posterior distribution $p(\mathbf{w} | D)$ of the vector of   weights is a Gaussian. Compute the posterior mean vector   $E[\mathbf{w}]$ and the posterior covariance in terms of the matrix  $\mathbf{X}$ where $X_{lk} = \Phi_k(x_l)$.
"""

# ╔═╡ 44d8c0f2-294c-4592-8884-c70427515170
md"""
- ### (b) [MATH] Derive an EM algorithm for optimising the hyperparameter $\beta$  by maximising the log-evidence

\begin{align}
p(D | \alpha, \beta) = \int p(D | \mathbf{w}, \beta) p(\mathbf{w}
| \alpha) \; d\mathbf{w}
\end{align}

!!! tip
	Hint: Treat the weights $\mathbf{w}$ as a set of latent
	variables similar to the procedure for $\alpha$ given in the
	lecture. Express your result in terms of the posterior mean and
	variance.
"""

# ╔═╡ e206b903-26ee-45c8-a143-acdef4d43538
md"""
### (c) [CODE] Implement the posterior solution of a generalised linear model given an arbitrary base function $\Phi(X)=\{\Phi_1(X), \ldots, \Phi_K(X)\}$
"""

# ╔═╡ 383fbefa-1772-4b77-a023-af74cd27308b
begin
	# Φ(x::Real) = [x] # Linear Case
	# Φ(x::Real) = [1, x, sin(x), cos(x)] 
	Φ(x::Real) = [one(x), x, x^2, x^3]#evalpoly(x, ones(4))
	Φ(x::Vector) = mapreduce(Φ, hcat, x) # Create a matrix out of a vector
end

# ╔═╡ 7bed2125-8ee9-438a-bf75-09f517381595
function posterior_params(val_Φ, y, α, β)
    ## !! FILL IN !!
	## This function should return the mean and the covariance of the posterior
	μ = ...
	Σ = ...
	return μ, Σ
end

# ╔═╡ 07ba0b78-3f11-4fa9-9762-c851bcecf7ff
md"""
### (d) [CODE] Given some random data, implement the EM algorithm to optimize $\alpha$ and $\beta$
"""

# ╔═╡ 27ef00e2-bf5e-4600-b6ce-c258b47f0a0b
md"""
\# data points : $(ndata = @bind Nx Slider(2:100; show_value=true, default=10))
"""

# ╔═╡ 095c1afc-4099-4b44-9bb9-3776c268692f
md"""β = $(@bind β_true Slider(0.001:0.1:10; default=1.0, show_value=true))"""

# ╔═╡ b6fa0eda-0c64-4f51-9216-92f113f6eff5
begin # Create some data
	X = rand(Uniform(-5, 5), Nx); # Sample X uniformly
	offset = 3
	X_test = collect(range(-5 - offset, 5 + offset, length = 500))
	w_true = [2.0, -0.1, 0.5, -0.2]
	f = evalpoly.(X, Ref(w_true)); # return w[0] + w[1] X + w[2] X^2 + ....
	y = f + randn(Nx) / sqrt(β_true); # Add some noise
end;

# ╔═╡ 751ed572-96e6-4630-9c0e-ffea19eac52d
begin
	scatter(X, y; xlabel="x", ylabel="y", label= "y")
	plot!(X_test, evalpoly.(X_test, Ref(w_true)); label="f")
end

# ╔═╡ 993a76a0-1188-4aba-a408-2a8dedf035b8
update_α(μ, Σ, K) = ## !! FILL IN !! Return the optimal alpha parameter

# ╔═╡ 36027f03-6e45-48b5-b652-59f2c8d925f0
update_β(val_Φ, y, μ, Σ) = ## !! FILL IN !! Return the optimal beta parameter

# ╔═╡ aa0d1e1b-56f1-410e-a598-7788c818d807
function expectation_step(val_Φ, y, μ, Σ, K, α, β)
    ## !! FILL IN !! Return the value of L
end

# ╔═╡ bd86335e-5e2d-48b3-b09a-fc0abdebf29b
begin
	α = 1.0 # Initial parameters
	β = 1.0
	val_Φ = Φ(X) # Feature map
	T = 10 # Number of steps
	K = size(val_Φ, 1) # Feature map dimension
	for i in 1:T
		μ, Σ = posterior_params(val_Φ, y, α, β)
		println("i = $i, pre L = $(expectation_step(val_Φ, y, μ, Σ, K, α, β)), α = $α, β = $β")
		α = update_α(μ, Σ, K)
		β = update_β(val_Φ, y, μ, Σ)
		println("i = $i, post L = $(expectation_step(val_Φ, y, μ, Σ, K, α, β)), α = $α, β = $β")
	end
end

# ╔═╡ 038874f9-e09e-4732-9a0c-44fa1f983b48
begin
	μ, Σ = posterior_params(val_Φ, y, α, β)
	plot(
		bar([μ, w_true], label = ["E[w]" "True w"], alpha = 0.5, lw = 0.0),
		heatmap(Σ, title = "Cov(w)", yflip =true),
	)
end

# ╔═╡ eb208c6c-bfa9-4063-a28a-2e7cba67afdb
begin
	scatter(X, y, lab= "y", xlabel="x", ylabel="y")
	plot!(X_test, Φ(X_test)' * μ; lab="Prediction", linewidth=5.0)
	plot!(X_test, evalpoly.(X_test, Ref(w_true)); linestyle=:dash, color=:black, label="f")
end

# ╔═╡ 8feb8a73-f6a7-4545-b3bb-0041d40ae251
md"""
We can also sample from the posterior to visualize all the different possibilities
"""

# ╔═╡ b0c4fc55-5ff7-4775-b871-f0da4a8935f0
ndata

# ╔═╡ 2bbd72f0-5bf6-46da-a856-3d9981ed0012
begin
	p = scatter(X, y, lab= "y", xlabel="x", ylabel="y")
	S = 100
	for i in 1:S
		w = rand(MvNormal(μ, Symmetric(Σ)))
		plot!(X_test, Φ(X_test)' * w; lab="", color=:black, alpha=0.01)
	end
	p
end

# ╔═╡ 8a696e31-f5ed-4bb2-a855-6a5f2707821b
(;α, β)

# ╔═╡ 8ab24959-d43f-4640-a695-aea1ea70fd57
β_true

# ╔═╡ f5e2b226-917f-4d2a-ae55-1ae771883d60
function fill_in()
	md"*Write your answer here or on paper*"
end

# ╔═╡ 0cebe584-6bd0-4582-aa09-e4729f925c3c
fill_in()

# ╔═╡ 846ca6b0-362c-4d18-906f-720ce199287a
fill_in()

# ╔═╡ 72224a44-abec-4463-a0e7-9b657198608c
fill_in()

# ╔═╡ c2125674-0b44-421d-9e71-02e66eca76ca
fill_in()

# ╔═╡ d44fe112-76fc-4cf5-bcd0-730afb35b953
fill_in()

# ╔═╡ e724110d-0dc9-4392-b7e4-e00a2425cbf4
fill_in()

# ╔═╡ Cell order:
# ╟─aff9e39c-f80a-4bab-a3c3-89520ce7bf16
# ╠═6014322e-bd4a-4cf3-8ac3-0d528b9d4b59
# ╟─33885d8f-4c8a-47de-9d3b-62ac35916a77
# ╟─d3f9b7b9-6ff0-48ef-875b-ec02871d4e43
# ╟─a17a1352-be6c-4df9-8b60-b9eb646cee10
# ╟─c55fcb2c-e738-4dae-a63d-e5d8f3243999
# ╟─0cebe584-6bd0-4582-aa09-e4729f925c3c
# ╟─488e44f2-140d-4ec5-a6a9-a0da44ef2789
# ╟─846ca6b0-362c-4d18-906f-720ce199287a
# ╟─ec62a4b1-b5db-4c68-a4a3-3d70d2608bc9
# ╟─72224a44-abec-4463-a0e7-9b657198608c
# ╟─5e5a551b-8575-4981-ae2e-7947db88660e
# ╟─c2125674-0b44-421d-9e71-02e66eca76ca
# ╟─065ecdf2-a172-4bfa-a5c9-53263af11232
# ╠═4bc2828b-155f-49f9-b0c3-95b90dd05d9a
# ╠═b23659fc-774b-4c98-9a93-498e538bd45b
# ╠═f3f9d85a-d5c0-4e01-a54f-dcf08872650d
# ╠═d1e8e03f-2185-4832-906c-97f29c0a99ce
# ╠═e538341a-b015-4f2b-84fa-9f9cbc5f4f42
# ╠═be22cc8d-d3f2-4254-88f1-b4da7610a485
# ╠═2a5c42f6-3b3d-4f0b-baa7-e41ecba20e07
# ╠═a6dad265-2bc4-47b1-8ff5-44ccefdca76f
# ╠═3ef9ea88-6d93-4615-8d2e-b3c03fa4cebc
# ╟─2a42c84f-ad7b-4a99-9a17-56ad2530cf75
# ╠═34705486-aa02-40eb-b1b6-432d25708e36
# ╟─59e60a2c-cf16-4055-80ab-b3b30651e5ff
# ╟─ece15487-f139-4952-a75b-c964ae06beb9
# ╟─0344ce71-c040-4a0b-8ae2-6bbf49aa272e
# ╟─d44fe112-76fc-4cf5-bcd0-730afb35b953
# ╟─44d8c0f2-294c-4592-8884-c70427515170
# ╟─e724110d-0dc9-4392-b7e4-e00a2425cbf4
# ╟─e206b903-26ee-45c8-a143-acdef4d43538
# ╠═383fbefa-1772-4b77-a023-af74cd27308b
# ╠═7bed2125-8ee9-438a-bf75-09f517381595
# ╟─07ba0b78-3f11-4fa9-9762-c851bcecf7ff
# ╟─27ef00e2-bf5e-4600-b6ce-c258b47f0a0b
# ╟─095c1afc-4099-4b44-9bb9-3776c268692f
# ╠═b6fa0eda-0c64-4f51-9216-92f113f6eff5
# ╟─751ed572-96e6-4630-9c0e-ffea19eac52d
# ╠═993a76a0-1188-4aba-a408-2a8dedf035b8
# ╠═36027f03-6e45-48b5-b652-59f2c8d925f0
# ╠═aa0d1e1b-56f1-410e-a598-7788c818d807
# ╠═bd86335e-5e2d-48b3-b09a-fc0abdebf29b
# ╠═038874f9-e09e-4732-9a0c-44fa1f983b48
# ╠═eb208c6c-bfa9-4063-a28a-2e7cba67afdb
# ╟─8feb8a73-f6a7-4545-b3bb-0041d40ae251
# ╟─b0c4fc55-5ff7-4775-b871-f0da4a8935f0
# ╠═2bbd72f0-5bf6-46da-a856-3d9981ed0012
# ╠═8a696e31-f5ed-4bb2-a855-6a5f2707821b
# ╠═8ab24959-d43f-4640-a695-aea1ea70fd57
# ╟─f5e2b226-917f-4d2a-ae55-1ae771883d60
