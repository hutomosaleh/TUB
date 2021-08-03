### A Pluto.jl notebook ###
# v0.14.2

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

# ╔═╡ 5f64c654-3359-4f47-8179-e917a3e000bd
begin
	import Pkg # The best package manager in the world
	Pkg.activate(".") # Create a local environment in the current directory
	Pkg.add(["Distributions", "Plots", "Optim", "PlutoUI"]);
	## Those are needed packages for the different exercises
	using Distributions # Basic library to use probability distributions
	using LinearAlgebra # Standard library for linear algebra operations
	using Plots # Front end for multiple plotting backends, by default it will use GR
	default(linewidth = 3.0, legendfontsize = 15.0) # Some default values for our plotting
	using Optim # Optimisation library
	using PlutoUI # Some Pluto sugar
end

# ╔═╡ ec6f2a9d-f061-4cbb-8068-92e55b0af2a0
md"""
# Problem Sheet 1
"""

# ╔═╡ 8b8eb682-bdd6-4100-b1f3-d71943a3114b
md"""
First a couple of packages needs to be used.
This will automatically install these packages in a local environment (where the file is currently is.
If you would like to do that manually you can open a terminal with Julia and write `] add Distributions` for example
"""

# ╔═╡ 23fc2bdb-5630-4067-842c-cbc1f28f1174
#TableOfContents()

# ╔═╡ 4ebaf836-35b1-4319-a4f8-b82ec90db952
md"""
## 1. Random experiments
"""

# ╔═╡ 60148842-798b-416a-a908-99d4de9cf1f6
md"""
A dice is thrown repeatedly until it shows a $6$. Let $T$ be the
number of throws for this to happen and $q$ the probability to **not** get a 6. Obviously, $T$ is a random
variable.
"""

# ╔═╡ 2249fb76-6085-42ed-9ac7-e9f594632920
md"""
### (a) [MATH] Compute the expectation value $E[T]$ and the variance $V[T]$ of $T$.
"""

# ╔═╡ 76058486-5989-4872-8c2e-fb1e4f3e5737
md"""$(g_q_float = @bind q_float Slider(1/6:1/6:5/6; default=5/6, show_value=true))"""

# ╔═╡ 73975a14-54e1-41d5-916e-4a3a49f28c31
q = let q_float=q_float
	v = 1//6:1//6:5//6
	i = findfirst((≈)(q_float), v)
	v[i]
end

# ╔═╡ 23496edd-777a-438f-9fdd-581e53f324d2
md"""
You can write your answer here or on paper.
For inline LaTeX use `$\alpha$` and for multiline equations use three backticks: 

\`\`\`math

\`\`\`
"""

# ╔═╡ 655546c4-3723-44ab-a079-93e83597875e
md"""
#### (b) Write a program to empirically estimate the mean and the variance of $T$ and compare it to the value you found analytically
"""

# ╔═╡ 329e2153-fbd4-4a04-9683-a92a9ceaf4c0
g_q_float

# ╔═╡ c531083e-92d4-11eb-2765-11c35a8b7327
begin
	N_tries = 10000 # Number of times we run the experiment
	T_vals = zeros(N_tries) # Preallocation of T value at every experiment
	expec_T = zeros(N_tries) # Preallocation of the expectation of T over time
	var_T = zeros(N_tries) # Preallocation of the variance of T over time
	for i in 1:N_tries
		T = 1
		## !! CODE MISSING !! ##
		## Write here your code to run a random experiment where T increments
		## Until a 6 is obtained
		## Use q the probability of not having a 6
		## !! CODE MISSING !! ##
		T_vals[i] = T
		expec_T[i] = mean(T_vals[1:i])
		var_T[i] = var(T_vals[1:i])
	end
end;

# ╔═╡ 0aa93616-d88b-47ca-9c63-e8ec56334f58
md"""
## 2. Addition of Variances
"""

# ╔═╡ bf7f4b27-029e-4522-a6b5-907bfc1ff1ca
md"""
Let $X$ and $Y$ be independent random variables. Show that:

```math
\text{Var}(X+Y) = \text{Var}(X) + \text{Var}(Y),
```

where the variance is defined as : 

```math
\text{Var}(X) = E[(X-E[X])^2].
```

!!! tip
	Use the fact that for independent $U$ and $V$, $E[UV] = E[U]E[V]$
"""

# ╔═╡ 47973f9c-aac2-4e65-a6f9-62d1c5d008fe
md"""
Write your answer here or on paper
"""

# ╔═╡ b09b58da-4119-4ba4-8daf-6ac95042a761
md"""Full covariance ? $(g_fullcov = @bind fullcov CheckBox(;default=false))"""

# ╔═╡ 1b6b3b65-2b85-416f-8efe-53195a0ef107
md"""
E[x] = $(@bind mean_x Slider(-5:0.01:5; default=2.0, show_value=true))
Var[x] = $(@bind var_x Slider(0.01:0.01:5; default=3.0, show_value=true))

E[y] = $(@bind mean_y Slider(-5:0.01:5; default=1.0, show_value=true))
Var[y] = $(@bind var_y Slider(0.01:0.01:5; default=2.0, show_value=true))
"""

# ╔═╡ 7f1f320d-0e93-4a4f-8c0a-529bb1d93271
if fullcov
	m = sqrt(var_x * var_y)
	md"""
	Cov(x, y) = $(g_cov_xy = @bind cov_xy Slider(-m:0.01:m; default=1.0, show_value=true))
	"""
else
	cov_xy = 0.0;
	md" "
end

# ╔═╡ 8a1a1c34-92d6-11eb-36bd-b39e2962664a
dist_x = Normal(mean_x, sqrt(var_x))

# ╔═╡ 8a1b12f6-92d6-11eb-0d8e-4d1861e4f6ed
dist_y = Normal(mean_y, sqrt(var_y))

# ╔═╡ 7f85e534-1eec-471f-a65b-33515e73e1c5
if fullcov
	dist_xy = MvNormal([mean_x, mean_y], [var_x cov_xy; cov_xy var_y])
end

# ╔═╡ 84b928a6-dd93-486c-a3de-a47f48e1b893
begin
	p_marginals = plot(-10:0.01:10, [x->pdf(dist_x, x), x->pdf(dist_y, x)]; label=["p(x)" "p(y)"], xlabel="x", size=(400, 400))
	if fullcov
		p_fullcov = contourf(-10:0.1:10, -10:0.1:10, (x,y)->pdf(dist_xy, [x,y]),lw=0.0, colorbar=false, xlabel="x", ylabel="y", color=:blues, size=(400, 400))
		plot(p_marginals, p_fullcov, size=(800, 400))
	else
		p_marginals
	end
end

# ╔═╡ 8a6e1bfe-92d6-11eb-14a6-0108e90631ce
begin
	nSamples = 10000; # Number of samples we use
	# Preallocation
	xs = zeros(nSamples)
	ys = zeros(nSamples)
	vars = zeros(nSamples)
	for i in 1:nSamples
		if fullcov
			xs[i], ys[i] = rand(dist_xy)
		else
			xs[i] = rand(dist_x)
			ys[i] = rand(dist_y)
		end
		vars[i] = var(xs[1:i] .+ ys[1:i])
	end
end

# ╔═╡ 1b807c80-750e-41b2-ac10-0cdb2034f4bf
md"""Full covariance? $(g_fullcov)"""

# ╔═╡ 15b408a3-21e5-4d9a-b942-b1d99b7077d2
if fullcov
	md"""Cov(x,y) = $(g_cov_xy)"""
end

# ╔═╡ 8a8086fe-92d6-11eb-0c0c-e74c55f50f33
begin
	plot(vars; label = "Var(X+Y)", legend=:bottomright)
	hline!([var_x + var_y]; label="$(var_x + var_y)")
end

# ╔═╡ c3ca1c92-972f-4d34-a9c6-937ec7c06129
md"""
## 3. Transformation of probability densities
"""

# ╔═╡ 516e0aa5-779d-4a0b-9c9d-04e0cad38988
md"""
Let $X$ be uniformly distributed in $(0, 1)$:

```math
\begin{align}
  p(x) = \left\{
    \begin{array}{cl}
      1 & \textrm{for  } 0 < x < 1, \\
      0 & \textrm{otherwise.}
    \end{array}
  \right.
\end{align}
```

A second random variable $Y$ is defined as

```math
\begin{align}
  Y = \tan \left( \pi (X - 1/2) \right).
\end{align}
```

What is the probability density $q(y)$ of $Y$?
"""

# ╔═╡ fd5a989a-92ef-4c92-9f57-1148f6dc72fa
md"""
Write your answer here or on paper
"""

# ╔═╡ 3614578a-90de-4886-a74a-dd5e5de23cdb
begin
	p_uni = plot(-0.5:0.01:1.5, x->pdf(Uniform(0, 1), x); title="Uniform", label="")
	p_cauchy = plot(-5:0.01:5, x->pdf(Cauchy(), x); title="Cauchy", label="")
	plot(p_uni, p_cauchy)
end

# ╔═╡ 42c1cbb8-e2bd-4d71-9eec-a9a8477a80ae
md"""
## 4. Gaussian Inference
"""

# ╔═╡ 501b63b9-0bf9-4ed5-bc65-202d5e416616
md"""
Suppose we have two random variables $V_1$ and $V_2$ which are **jointly Gaussian** distributed 
with zero means $E[V_1] = E[V_2] = 0$ and variances $E[V_1^2] = 16.6$ and $E[V_2^2] =6.8$. The
covariance is $E[V_1\; V_2] = 6.4$.  

Assume that we observe a noisy estimate $$Y = V_2 + \nu$$ of $V_2$ where
$\nu$ is a Gaussian noise variable independent of $V_1$ and of $V_2$ with $E[\nu] = 0$ and $E[\nu^2] =1$.
"""

# ╔═╡ 00981117-4391-4f92-a167-78509ec5cebd
md"""
!!! tip 
	The following formula could be helpful: The inverse of the matrix
	```math
	\begin{eqnarray*}
	{\bf A} = 
	\left(\begin{array}{ccc}
	a_{11} & a_{12} \\
	a_{21} & a_{22}  \\
	\end{array}\right)
	\end{eqnarray*}
	```
	is given by
	```math
	\begin{eqnarray*}
	{\bf A}^{-1} =
	\frac{1}{\mbox{det}{{\bf A}}}\left(\begin{array}{ccc}
	a_{22} & - a_{12} \\
	-a_{21} & a_{11} \\
	\end{array}\right)
	\end{eqnarray*}
	```
"""

# ╔═╡ 649a3f0c-fc8a-4e9a-afc6-8b79d47a2079
md"""
### (a) Obtain the conditional densities $p(V | Y)$ from the joint densities $p(V, Y)$. (Here $V$ can be either $V_1$ or $V_2$) !
"""

# ╔═╡ 871574bf-fe8d-4bf4-b36e-257c01be27be
md"""
Write your answers here or on paper
"""

# ╔═╡ bb19ace8-968b-4f67-99c1-1f98a401b4f5
md"""
### (b) What are the posterior mean predictions of $V_1$ and $V_2$ for an observation $Y=1$ and what are the posterior uncertainties of these predictions.
"""

# ╔═╡ c39a9874-622a-4310-b3b4-1c44f7fb33ea
md"""
Write your answers here or on paper
"""

# ╔═╡ 423e858a-2d93-46f8-8912-06ad3d251085
begin
	lim = 10.0
	S_V1V2 = [16.6 6.4
	           6.4 6.8]
	dV1V2 = MvNormal(S_V1V2)
	scatter(eachrow(rand(dV1V2, 1000))..., title="Samples from V1, V2", xlabel="v1", ylabel="v2", msw=0.0, alpha=0.5, lab="p(v1, v2)", xlims=(-lim, lim), ylims=(-lim, lim))
end

# ╔═╡ 1273c58d-808c-4389-acae-ef34e91d10e6
md"""ν = $(@bind ν Slider(0.1:0.1:5; default=1.0, show_value=true))"""

# ╔═╡ 81031818-568f-424d-a36a-bba7a7acc182
md"""y = $(@bind y Slider(-10:0.1:10; default=1, show_value=true))"""

# ╔═╡ 2d26e182-b384-4936-b076-243f97bb8a68
begin
	S_V1Y = [16.6 6.4
	          6.4 6.8 + ν]
	dV1Y = MvNormal(S_V1Y)
end

# ╔═╡ ff731e78-92f3-11eb-042e-9febf37c372e
begin
	p3 = scatter(eachrow(rand(dV1Y, 1000))..., msw = 0.0, alpha = 0.5, lab = "p(v1, y)", lims = (-lim, lim))
	hline!([y]; lab="Y=$y")
	Sinv = inv(S_V1Y)
	m_cond_Y = -Sinv[1, 2] / Sinv[1, 1] * y
	var_cond_Y = 1 / Sinv[1, 1]
	dV1_cond_Y = Normal(m_cond_Y, sqrt(var_cond_Y))
	p4 = plot(-lim:0.01:lim, x->pdf(dV1_cond_Y, x), label = "p(v1 | y = $y)")
	plot(p3,p4; layout=grid(2,1),size=(500, 800))
end

# ╔═╡ 3fe9e12c-78e7-4f28-a2c6-251961c8a266
md"""
## 5. Maximum Likelihood
"""

# ╔═╡ a58f60b2-6b84-40ca-a9b5-93f0a28de5e7
md"""
- ### (a) How can you use the results of **problem 3** to generate a dataset of $n=1000$ independent random numbers $D= (x_1,\ldots, x_n)$ from a Cauchy density
\begin{align}
      p(x |\theta) =  \frac{1}{\pi} \frac{1}{1 + (x - \theta)^2}
\end{align}
### when $\theta \neq 0$.
"""

# ╔═╡ 4c17255e-1a8e-4be2-8e19-015209eb5f74
md"""
Write your answers here or on paper
"""

# ╔═╡ 7943fda9-d780-4344-81f4-73d8db372e1e
md"""
- ### (b) Write down an expression for the log--likelihood $\ln p(D |\theta)$ for independent Cauchy data.
"""

# ╔═╡ f5a7820b-f132-43cc-b4c6-55584c8ab792
md"""
Write your answers here or on paper
"""

# ╔═╡ f64bca87-c698-4200-90f3-0b1049ee5e23
md"""
- ### (c) Set $\theta =1$, generate a Cauchy dataset  $D$  and use numerical optimisation to find the maximum likelihood estimator  $\hat{\theta}_{ML}(D)$. 
"""

# ╔═╡ e5eb11ef-7371-4407-9583-619a9f4bc570
# Generate a dataset D of Cauchy variables
function generate_D(N, θ)
	## !! CODE MISSING !! ##
	## The function should return a vector of random Cauchy variables of size N
	## !! CODE MISSING !! ##
end;

# ╔═╡ 6feedfc0-92f4-11eb-1d74-eb8d1d088616
md"""
θ = $(@bind θ Slider(range(-10.0, 10.0, length=101); default=1.0, show_value=true))
"""

# ╔═╡ 6ff16cc2-92f4-11eb-1e8e-d749d9bc9e09
D = generate_D(1000, θ) # Generate the dataset;

# ╔═╡ 7001fa4c-92f4-11eb-0d03-390aa7ff4014
function log_likelihood(ys, θ) # Compute the loglikelihood
	## !! CODE MISSING !! ##
	## The function should return the total loglikelihood for the observations ys given the parameter θ
	## !! CODE MISSING !! ##
end;

# ╔═╡ 700ff61a-92f4-11eb-33c3-ab7294c2efc2
# We call optimize, from Optim.jl. Since we want to maximize
# but optimize minimizes we give the negative value
if D !== nothing
	θML = optimize(x -> -log_likelihood(D, first(x)), [0.5], BFGS()).minimizer[1]
end

# ╔═╡ ce38dfe0-259d-4aff-9e91-07735403b029
md"""
- ### (d) Repeat the estimation for $M =100$ independent data sets $(D_1,\ldots, D_{100})$ and report the empirical mean and variance of the ML estimators.
"""

# ╔═╡ 48aaf1f5-0cbb-4698-9801-436b80b3fd31
begin
	N = 1000 # Size of dataset
	M = 100 # Number of tries
end;

# ╔═╡ 664327b4-92f5-11eb-05f2-5130953d617c
begin
	if D !== nothing
		θs_ML = [ # Repeat the ML estimator M times
			begin # This is a comprehension
				## !! CODE MISSING !! ##
				## Write here a function generating a random dataset and evaluating the ML estimator
				## !! CODE MISSING !! ##
			end
		for _ in 1:M]
		(mean = mean(θs_ML), variance = var(θs_ML))
	end
end;

# ╔═╡ 11368f32-92f6-11eb-0e4c-999edb341768
begin
	histogram(θs_ML; title="Histogram of estimators", bins=20, lw=0.0, label="", xlabel="θₘₗ")
	vline!([θ], label="True value")
end

# ╔═╡ 13fc672f-e714-4bc9-a0c4-abd7b8b96103
md"""
- ### (e) Report mean and variance of  a naive estimator $\hat{\theta}_{naive}(D) \doteq \frac{1}{n} \sum_{i=1}^n x_i$ on the same datasets.
"""

# ╔═╡ 62421494-8697-480d-b756-bb7538a0d7ea
begin
	N_naive = 10000
	M_naive = 10000
	if D !== nothing
		θs_naive = map(1:M) do _
			## !! CODE MISSING !! ##
			## Fill in here code generating a random dataset and evaluating the naive estimator
			## !! CODE MISSING !! ## 
		end
		(mean = mean(θs_naive), variance = var(θs_naive))
	end
end

# ╔═╡ 1a4a4e57-9fe2-4481-a3bb-6f9a1dc297fc
begin
	histogram(θs_naive; title="Histogram of estimators", bins=20, lw=0.0, label="", xlabel="θₘₗ")
	vline!([θ], label="True value")
end

# ╔═╡ Cell order:
# ╟─ec6f2a9d-f061-4cbb-8068-92e55b0af2a0
# ╟─8b8eb682-bdd6-4100-b1f3-d71943a3114b
# ╠═5f64c654-3359-4f47-8179-e917a3e000bd
# ╠═23fc2bdb-5630-4067-842c-cbc1f28f1174
# ╟─4ebaf836-35b1-4319-a4f8-b82ec90db952
# ╟─60148842-798b-416a-a908-99d4de9cf1f6
# ╟─2249fb76-6085-42ed-9ac7-e9f594632920
# ╟─76058486-5989-4872-8c2e-fb1e4f3e5737
# ╟─73975a14-54e1-41d5-916e-4a3a49f28c31
# ╟─23496edd-777a-438f-9fdd-581e53f324d2
# ╟─655546c4-3723-44ab-a079-93e83597875e
# ╟─329e2153-fbd4-4a04-9683-a92a9ceaf4c0
# ╠═c531083e-92d4-11eb-2765-11c35a8b7327
# ╟─0aa93616-d88b-47ca-9c63-e8ec56334f58
# ╟─bf7f4b27-029e-4522-a6b5-907bfc1ff1ca
# ╟─47973f9c-aac2-4e65-a6f9-62d1c5d008fe
# ╟─b09b58da-4119-4ba4-8daf-6ac95042a761
# ╟─1b6b3b65-2b85-416f-8efe-53195a0ef107
# ╟─7f1f320d-0e93-4a4f-8c0a-529bb1d93271
# ╟─8a1a1c34-92d6-11eb-36bd-b39e2962664a
# ╟─8a1b12f6-92d6-11eb-0d8e-4d1861e4f6ed
# ╟─7f85e534-1eec-471f-a65b-33515e73e1c5
# ╟─84b928a6-dd93-486c-a3de-a47f48e1b893
# ╠═8a6e1bfe-92d6-11eb-14a6-0108e90631ce
# ╟─1b807c80-750e-41b2-ac10-0cdb2034f4bf
# ╟─15b408a3-21e5-4d9a-b942-b1d99b7077d2
# ╟─8a8086fe-92d6-11eb-0c0c-e74c55f50f33
# ╟─c3ca1c92-972f-4d34-a9c6-937ec7c06129
# ╟─516e0aa5-779d-4a0b-9c9d-04e0cad38988
# ╟─fd5a989a-92ef-4c92-9f57-1148f6dc72fa
# ╟─3614578a-90de-4886-a74a-dd5e5de23cdb
# ╟─42c1cbb8-e2bd-4d71-9eec-a9a8477a80ae
# ╟─501b63b9-0bf9-4ed5-bc65-202d5e416616
# ╟─00981117-4391-4f92-a167-78509ec5cebd
# ╟─649a3f0c-fc8a-4e9a-afc6-8b79d47a2079
# ╟─871574bf-fe8d-4bf4-b36e-257c01be27be
# ╟─bb19ace8-968b-4f67-99c1-1f98a401b4f5
# ╟─c39a9874-622a-4310-b3b4-1c44f7fb33ea
# ╟─423e858a-2d93-46f8-8912-06ad3d251085
# ╟─1273c58d-808c-4389-acae-ef34e91d10e6
# ╟─81031818-568f-424d-a36a-bba7a7acc182
# ╟─2d26e182-b384-4936-b076-243f97bb8a68
# ╟─ff731e78-92f3-11eb-042e-9febf37c372e
# ╟─3fe9e12c-78e7-4f28-a2c6-251961c8a266
# ╟─a58f60b2-6b84-40ca-a9b5-93f0a28de5e7
# ╟─4c17255e-1a8e-4be2-8e19-015209eb5f74
# ╟─7943fda9-d780-4344-81f4-73d8db372e1e
# ╟─f5a7820b-f132-43cc-b4c6-55584c8ab792
# ╟─f64bca87-c698-4200-90f3-0b1049ee5e23
# ╠═e5eb11ef-7371-4407-9583-619a9f4bc570
# ╟─6feedfc0-92f4-11eb-1d74-eb8d1d088616
# ╠═6ff16cc2-92f4-11eb-1e8e-d749d9bc9e09
# ╠═7001fa4c-92f4-11eb-0d03-390aa7ff4014
# ╠═700ff61a-92f4-11eb-33c3-ab7294c2efc2
# ╟─ce38dfe0-259d-4aff-9e91-07735403b029
# ╠═48aaf1f5-0cbb-4698-9801-436b80b3fd31
# ╠═664327b4-92f5-11eb-05f2-5130953d617c
# ╠═11368f32-92f6-11eb-0e4c-999edb341768
# ╟─13fc672f-e714-4bc9-a0c4-abd7b8b96103
# ╠═62421494-8697-480d-b756-bb7538a0d7ea
# ╠═1a4a4e57-9fe2-4481-a3bb-6f9a1dc297fc
