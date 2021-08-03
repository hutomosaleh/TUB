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
	using Random
end

# ╔═╡ ec6f2a9d-f061-4cbb-8068-92e55b0af2a0
md"""
# Problem Sheet 1- With Solutions
"""

# ╔═╡ 8b8eb682-bdd6-4100-b1f3-d71943a3114b
md"""
First a couple of packages needs to be used.
This will automatically install these packages in a local environment (where the file is currently is.
If you would like to do that manually you can open a terminal with Julia and write `] add Distributions` for example
"""

# ╔═╡ 5c11d49f-2496-4317-a0fb-d741062fb311
html"<button onclick=present()>Present</button>"

# ╔═╡ ba25b4cc-b174-4f9f-b2bf-ca36d87f4f3b
TableOfContents()

# ╔═╡ 4ebaf836-35b1-4319-a4f8-b82ec90db952
md"""
## 1. Random experiments
"""

# ╔═╡ 60148842-798b-416a-a908-99d4de9cf1f6
md"""
A dice is thrown repeatedly until it shows a $6$. Let $T$ be the
number of throws for this to happen. Obviously, $T$ is a random
variable. 
"""

# ╔═╡ 2249fb76-6085-42ed-9ac7-e9f594632920
md"""
### (a) [MATH] Compute the expectation value $E[T]$ and the variance $V[T]$ of $T$.
"""

# ╔═╡ 1f0fab1c-c18c-42ac-be83-a74cffdbb9ab
md"""
- The probability for $t$ throws is given by the geometric
    distribution
    
```math
      P(T = t) = (1 - q) q^{t - 1}
```

with parameter $q = 5/6$.

---
"""

# ╔═╡ 76058486-5989-4872-8c2e-fb1e4f3e5737
md"""$(g_q_float = @bind q_float Slider(1/6:1/6:5/6; default=5/6, show_value=true))"""

# ╔═╡ 73975a14-54e1-41d5-916e-4a3a49f28c31
q = let q_float=q_float
	v = 1//6:1//6:5//6
	i = findfirst((≈)(q_float), v)
	v[i]
end

# ╔═╡ bead2715-8a59-4866-a61d-897cf45f76f5
scatter(0:50, x->pdf(Geometric(q_float), x); xlabel="T", ylabel="p(T)", label="p(x)", title="q = $(q)", ylims=(0,1))

# ╔═╡ b40ee741-307f-43ea-a9c9-cb9538f8a83e
md"""
- The expectation value of $T$ can be calculated using its definition:

```math
      E[T] = \sum_{t=1}^{\infty} t P(T = t) = \sum_{t=1}^{\infty} (1 - q) t q^{t - 1} = \sum_{t = 1}^{\infty} (1 - q) \frac{d}{dq} q^t
```

- As the geometric series converges absolutely, we can exchange summation and derivation:
    
```math
      E[T] = (1 - q) \frac{d}{dq} \sum_{t = 0}^{\infty} q^t = (1 - q)
      \frac{d}{dq} \frac{1}{1 - q} = (1 - q) \frac{1}{(1 - q)^2} =
      \frac{1}{1 - q}
```
"""

# ╔═╡ bd008564-d7f3-4dd1-ac22-6b53d14ac1b4
md"""
- In order to obtain the variance we need the expectation value
    of $T^2$, too:
    
```math
      E[T^2] = \sum_{t = 1}^{\infty} \, t^2 \, P(T = t) = \sum_{t =
        1}^{\infty} (1 - q) \, t^2 \, q^{t - 1}
```

- Here $t^2 \, q^{t - 1}$ is very similar to the second derivative of $q^{t + 1}$:
    
```math
      E[T^2] = \sum_{t = 1}^{\infty} (1 - q) \, t (t + 1) q^{t - 1} -
      \sum_{t = 1}^{\infty} (1 - q) t q^{t - 1} = -E[T] + \sum_{t =
        1}^{\infty} (1 - q) \frac{d^2}{dq^2} \, q^{t + 1}
```
"""

# ╔═╡ 23496edd-777a-438f-9fdd-581e53f324d2
md"""
- Further simplifications
    
```math
      E[T^2] = -\frac{1}{1 - q} + (1 - q) \frac{d^2}{dq^2} \sum_{t =
        0}^{\infty} q^t = -\frac{1}{1 - q} + (1 - q) \frac{d^2}{dq^2}
      \frac{1}{1 - q}
```

lead to

```math
      E[T^2] = -\frac{1}{1 - q} + (1 - q) \frac{2}{(1 - q)^3} = \frac{1
        + q}{(1 - q)^2}
```

so that the variance of $T$ is given by

```math
      V[T] = E[T^2] - E[T]^2 = \frac{1 + q}{(1 - q)^2} -
      \frac{1}{(1 - q)^2} = \frac{q}{(1 - q)^2}
```

- By substituting $q = 5/6$ we finally find $E[T] = 6$ and $V[T] = 30$.
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
		while !rand(Bernoulli(1-q)) || T > 10000 # Sample from a Bernoulli with prob q until we get a 6
			T += 1
		end
		T_vals[i] = T
		expec_T[i] = mean(T_vals[1:i])
		var_T[i] = var(T_vals[1:i])
	end
end;

# ╔═╡ c544453e-92d4-11eb-18ef-7b5986cf409e
begin # Plot the expectation
	p1 = plot(expec_T, label = "E[T]", legend=:bottomright) # Plot expectation over # of experiments
	hline!([1/(1-q)], label = "$(Float64(1/(1-q)))") # Plot the value we expect to see
end;

# ╔═╡ c563b7f0-92d4-11eb-14b7-bb6e83170955
begin # Plot the variance
	p2 = plot(var_T, label = "V[T]", legend=:bottomright) # Plot the computed variance
	hline!([q/(1-q)^2], label = "$(Float64(q/(1-q)^2))") # Plot the value we computed
end;

# ╔═╡ c5909664-92d4-11eb-1674-01f01535b18d
plot(p1, p2, size = (700,300))

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

**Hint:** Use the fact that for independent $U$ and $V$, $E[UV] = E[U]E[V]$
"""

# ╔═╡ 47973f9c-aac2-4e65-a6f9-62d1c5d008fe
md"""
```math
\begin{align}
\text{Var}(X+Y) =& E[(X + Y - E[(X+Y)])^2] = E[(X - E[X] + Y - E[Y])^2]\\
=& E[(X-E[X])^2] + 2E[(X-E[X])(Y-E[X])] + E[(Y-E[Y])^2]\\
=& \text{Var}(X) + \text{Var}(Y) + 2 (E[XY] - 2 E[X]E[Y] + E[X]E[Y])\\
=& \text{Var}(X) + \text{Var}(Y)
\end{align}
```
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
- Inverse function:

```math
\begin{eqnarray*}
      y = \tan(\pi (x - 1/2))
      &\Longleftrightarrow& \arctan y = \pi (x - 1/2) \\
      &\Longleftrightarrow& x = \frac{1}{\pi} \arctan y + \frac{1}{2}
\end{eqnarray*}
```

- Transformation of probability densities:

```math
\begin{align}
      q(y) = p(x) \cdot \frac{dx}{dy} = p(x) \cdot \frac{1}{\pi}
      \frac{1}{1 + y^2} = \frac{1}{\pi} \frac{1}{1 + y^2}
\end{align}
```
- This transformation together with a (pseudo-)random number generator can be used to generate (pseudo-)random numbers with a standard Cauchy distribution.
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
### (a) We obtain the conditional densities $p(V | Y)$ from the joint densities $p(V, Y)$. (Here $V$ can be either $V_1$ or $V_2$) !
"""

# ╔═╡ 871574bf-fe8d-4bf4-b36e-257c01be27be
md"""
```math
\begin{align}
p(V, Y) = \frac{1}{2\pi \sqrt{\det({\bf S}})} \exp\left\{-\frac{1}{2} (V, \; Y)^\top 
{\bf S}^{-1} (V , \; Y)\right\}
\end{align}
```
Note $(V , \; Y)$ is a two dimensional vector and the covariance matrix is given by
```math
\begin{align}
{\bf S} = 
\left(\begin{array}{ccc}
E[V^2] & E[V   Y]\\
E[V   Y] & E[Y^2] \\
\end{array}\right)
\end{align}
```

The expectations are
```math
\begin{eqnarray*}
E[V_{1}   Y] & = & E[V_1 V_2] \\
E[V_{2}   Y]  & =  & E[V_2^2]  \\
E[ Y^2] & = & E[V_2^2] + E[\nu^2]
\end{eqnarray*}
```
We set
```math
\begin{eqnarray*}
{\bf S}^{-1} = \left(\begin{array}{ccc}
({\bf S}^{-1})_{vv} & ({\bf S}^{-1})_{v y}\\
({\bf S}^{-1})_{v y}& ({\bf S}^{-1})_{y y} \\
\end{array}\right)
\end{eqnarray*}
```
Then, from the joint density, we can write the conditional density as 
```math
p(V | Y) \propto \exp\left(- \frac{V^2}{2} ({\bf S}^{-1})_{vv} - V ({\bf S}^{-1})_{v y} Y\right)
```
- This can be written in the standard notation as
```math
p(V | Y) = \frac{1}{\sqrt{2\pi \sigma^2}} e^{\frac{(V- \mu)^2}{2\sigma^2}}
```
where
```math
\begin{eqnarray*}
\mu  = E[ V | Y] = - \frac{({\bf S}^{-1})_{v y} Y}{({\bf S}^{-1})_{vv}}  \\
\sigma^2 =  \mbox{VAR}[V | Y] = \frac{1}{({\bf S}^{-1})_{vv}} 
\end{eqnarray*}
```
are the conditional mean and variance. We can use $E[ V | Y]$ for prediction.  
$\mbox{VAR}[V | Y]$ would give us a measure for the error of such a prediction.
"""

# ╔═╡ bb19ace8-968b-4f67-99c1-1f98a401b4f5
md"""
### (b) What are the posterior mean predictions of $V_1$ and $V_2$ for an observation $Y=1$ and what are the posterior uncertainties of these predictions.
"""

# ╔═╡ c39a9874-622a-4310-b3b4-1c44f7fb33ea
md"""
- For $p(V_1|Y)$ we have 

```math
\begin{eqnarray*}
{\bf S} = 
\left(\begin{array}{ccc}
16.6 &  6.4\\
6.4 &  7.8 \\
\end{array}\right)
\end{eqnarray*}
```
and
```math
\begin{eqnarray*}
{\bf S}^{-1} = 
\left(\begin{array}{ccc}
  0.0881  & -0.0723\\
   -0.0723  &  0.1875\\
\end{array}\right)
\end{eqnarray*}
```
Hence $E[ V_1 | Y]= 0.8207$ and  $\mbox{VAR}[V_1 | Y] = 11.3507$.

- For $p(V_2|Y)$ we have 
```math
\begin{eqnarray*}
{\bf S} = 
\left(\begin{array}{ccc}
6.8 &  6.8\\
6.8 &  7.8 \\
\end{array}\right)
\end{eqnarray*}
```
and
```math
\begin{eqnarray*}
{\bf S}^{-1} = 
\left(\begin{array}{ccc}
  1.1471  & -1.0000 \\
   -1.0000   & 1.0000 \\
\end{array}\right)
\end{eqnarray*}
```
Hence $E[ V_2 | Y]=0.8718$ and  $\mbox{VAR}[V_2 | Y] = 0.8718$.
"""

# ╔═╡ 423e858a-2d93-46f8-8912-06ad3d251085
begin
	lim = 10.0
	S_V1V2 = [16.6 6.4
	           6.4 6.8]
	dV1V2 = MvNormal(S_V1V2)
	scatter(eachrow(rand(dV1V2, 1000))..., msw = 0.0, alpha = 0.5, lab = "p(v1, v2)", xlims = (-lim, lim), ylims = (-lim, lim))
end

# ╔═╡ e9b189b1-0625-49f0-9a13-caf64a4d0c7a
md"""ν = $(@bind ν Slider(0.1:0.1:10; default=1, show_value=true))"""

# ╔═╡ 2d26e182-b384-4936-b076-243f97bb8a68
begin
	S_V1Y = [16.6 6.4
	          6.4 16.8 + ν]
	dV1Y = MvNormal(S_V1Y)
end

# ╔═╡ b05934aa-a2d5-49aa-b337-198d31edb555
md"""y = $(@bind y Slider(-10:0.1:10; default=1, show_value=true))"""

# ╔═╡ ff731e78-92f3-11eb-042e-9febf37c372e
begin
	p3 = scatter(eachrow(rand(MersenneTwister(42), dV1Y, 1000))..., msw = 0.0, alpha = 0.5, lab = "p(v1, y)", lims = (-lim, lim))
	hline!([y],lab = "Y = $(y)")
	Sinv = inv(S_V1Y)
	σ² = 1 / Sinv[1, 1] 
	dV1_cond_Y = Normal(-σ² * Sinv[1, 2] * y, sqrt(σ²))
	p4 = plot(-lim:0.01:lim, x->pdf(dV1_cond_Y,x), label = "p(v1 | y = $(y))")
	plot(p3,p4; layout=grid(2,1))
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
One can redo the same derivation by adding $\theta$. This will lead to

\begin{align}
    Y = \theta + \tan(\pi(X-\frac{1}{2}))
\end{align}

One can generate uniform samples, using for instance a pseudo-random generator `rand()` in most programming languages. Then applying the transform from problem 3

"""

# ╔═╡ 7943fda9-d780-4344-81f4-73d8db372e1e
md"""
- ### (b) Write down an expression for the log--likelihood $\ln p(D |\theta)$ for independent Cauchy data.
"""

# ╔═╡ f5a7820b-f132-43cc-b4c6-55584c8ab792
md"""
The log likelihood for a dataset of $N$ independent points $y_i$ drawn from a cauchy distribution is given by :
```math
\begin{align}
    \log p(D|\theta) = \sum_{i=1}^N \log p(y_i|\theta) = - N \log \pi - \sum \log(1+(y_i-\theta)^2)
\end{align}
```
"""

# ╔═╡ f64bca87-c698-4200-90f3-0b1049ee5e23
md"""
- ### (c) Set $\theta =1$, generate a Cauchy dataset  $D$  and use numerical optimisation to find the maximum likelihood estimator  $\hat{\theta}_{ML}(D)$. 
"""

# ╔═╡ e5eb11ef-7371-4407-9583-619a9f4bc570
# Generate a dataset D of Cauchy variables
function generate_D(N, θ)
    u = rand(N)
    ys = θ .- tan.(π * (u .- 0.5))
end;

# ╔═╡ 6feedfc0-92f4-11eb-1d74-eb8d1d088616
md"""
θ = $(@bind θ Slider(range(-10.0, 10.0, length=101); default=1.0, show_value=true))
"""

# ╔═╡ 6ff16cc2-92f4-11eb-1e8e-d749d9bc9e09
D = generate_D(1000, θ) # Generate the dataset;

# ╔═╡ 7001fa4c-92f4-11eb-0d03-390aa7ff4014
function log_likelihood(ys, θ) # Compute the loglikelihood
    - length(ys) * log(π) - sum(log(1.0 + (y - θ)^2) for y in ys)
end;

# ╔═╡ 700ff61a-92f4-11eb-33c3-ab7294c2efc2
# We call optimize, from Optim.jl. Since we want to maximize
# but optimize minimizes we give the negative value
θML = optimize(x -> -log_likelihood(D, first(x)), [0.5], BFGS()).minimizer[1]

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
	θs_ML = [ # Repeat the ML estimator M times
		begin # This is a comprehension
			ys = generate_D(N, θ)
			optimize(x -> -log_likelihood(ys, first(x)), [0.0], 		 BFGS()).minimizer[1]
		end
	for _ in 1:M]
	(mean = mean(θs_ML), variance = var(θs_ML))
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
	θs_naive = map(1:M) do _
	    ys = generate_D(1000, θ)
	    return sum(ys)/N
	end
	(mean = mean(θs_naive), variance = var(θs_naive))
end

# ╔═╡ 1a4a4e57-9fe2-4481-a3bb-6f9a1dc297fc
begin
	histogram(θs_naive; title="Histogram of estimators", bins=20, lw=0.0, label="", xlabel="θₙₐᵢᵥₑ")
	vline!([θ], label="True value")
end

# ╔═╡ Cell order:
# ╟─ec6f2a9d-f061-4cbb-8068-92e55b0af2a0
# ╟─8b8eb682-bdd6-4100-b1f3-d71943a3114b
# ╠═5f64c654-3359-4f47-8179-e917a3e000bd
# ╟─5c11d49f-2496-4317-a0fb-d741062fb311
# ╟─ba25b4cc-b174-4f9f-b2bf-ca36d87f4f3b
# ╟─4ebaf836-35b1-4319-a4f8-b82ec90db952
# ╟─60148842-798b-416a-a908-99d4de9cf1f6
# ╟─2249fb76-6085-42ed-9ac7-e9f594632920
# ╟─76058486-5989-4872-8c2e-fb1e4f3e5737
# ╟─73975a14-54e1-41d5-916e-4a3a49f28c31
# ╟─bead2715-8a59-4866-a61d-897cf45f76f5
# ╟─1f0fab1c-c18c-42ac-be83-a74cffdbb9ab
# ╟─b40ee741-307f-43ea-a9c9-cb9538f8a83e
# ╟─bd008564-d7f3-4dd1-ac22-6b53d14ac1b4
# ╟─23496edd-777a-438f-9fdd-581e53f324d2
# ╟─655546c4-3723-44ab-a079-93e83597875e
# ╟─329e2153-fbd4-4a04-9683-a92a9ceaf4c0
# ╠═c531083e-92d4-11eb-2765-11c35a8b7327
# ╟─c544453e-92d4-11eb-18ef-7b5986cf409e
# ╟─c563b7f0-92d4-11eb-14b7-bb6e83170955
# ╠═c5909664-92d4-11eb-1674-01f01535b18d
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
# ╠═423e858a-2d93-46f8-8912-06ad3d251085
# ╟─e9b189b1-0625-49f0-9a13-caf64a4d0c7a
# ╠═2d26e182-b384-4936-b076-243f97bb8a68
# ╟─b05934aa-a2d5-49aa-b337-198d31edb555
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
# ╟─1a4a4e57-9fe2-4481-a3bb-6f9a1dc297fc
