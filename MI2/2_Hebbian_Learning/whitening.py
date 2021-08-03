from copy import deepcopy
import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

sns.set()

df = pd.read_csv('Files/pca4.csv')
x = df.to_numpy()

# Centering
for i in range(np.shape(x)[1]):
    m = np.mean(x[:, i])
    x[:, 1] = x[:, 1] - m

n = np.shape(x)[0]
sample = np.linspace(1, n, n)
fig = plt.figure(1, constrained_layout=True)
for i in range(np.shape(x)[1]):
    ax = fig.add_subplot(2, 2, i+1, xlabel='sample', ylabel='x')
    ax.title.set_text(f'Variable X{i+1}')
    ax.plot(sample, x[:, i])

# clean dataset
index = []
n = np.shape(x)[0]
for i in range(2):
    for j in range(n):
        val = x[j, i+2]
        if np.abs(val) > 5:
            index.append(j)

x_old = x
x = np.delete(x, index, 0)

# plot again
n = np.shape(x)[0]
sample = np.linspace(1, n, n)
fig = plt.figure(2, constrained_layout=True)
for i in range(np.shape(x)[1]):
    ax = fig.add_subplot(2, 2, i+1, xlabel='sample', ylabel='x')
    ax.title.set_text(f'Variable X{i+1}')
    ax.plot(sample, x[:, i])

# Eigendecomposition
c = np.cov(x_old.T)
w, v = np.linalg.eig(c)
e = deepcopy(v)
for i, val in enumerate(np.argsort(-w)):
    e[i] = v[val]
w_old = -np.sort(-w)

c = np.cov(x.T)
w, v = np.linalg.eig(c)
e = deepcopy(v)
for i, val in enumerate(np.argsort(-w)):
    e[i] = v[val]
w = -np.sort(-w)

# Plot
width = 0.3
fig = plt.figure(3, constrained_layout=True)
ax = fig.add_subplot(1, 1, 1, xlabel='PC', ylabel='EW')
ax.bar(np.arange(len(w)), w_old, width=width, label='original')
ax.bar(np.arange(len(w))+width, w, color='orange', width=width, label='cleaned')
ax.legend()

# Whitening
v = (np.diag(1 / np.sqrt(w)) @ e.T @ x.T).T

c_x = np.cov(x.T)
c_v = np.cov(v.T)
u = x @ e
c_pc = np.cov(u.T)

# Plot
fig, (ax1, ax2, ax3) = plt.subplots(1, 3)
g1 = sns.heatmap(c_x, cmap='viridis', linewidth=0.5, ax=ax1)
g2 = sns.heatmap(c_pc, cmap='viridis', linewidth=0.5, ax=ax2)
g3 = sns.heatmap(c_v, cmap='viridis', linewidth=0.5, ax=ax3)

plt.show()
