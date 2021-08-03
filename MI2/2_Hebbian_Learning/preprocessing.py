from copy import deepcopy
from matplotlib.gridspec import GridSpec
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv('Files/pca2.csv')
x = df.to_numpy()
x1 = x[:, 0]
x2 = x[:, 1]

# Centering
m = np.mean(x1)
x1 = x1 - m
m = np.mean(x2)
x2 = x2 - m
m = np.mean(x2)
x = np.array([x1, x2]).T

# Eigendecomposition
c = np.cov(x.T)
w, v = np.linalg.eig(c)
e = deepcopy(v)
for i, val in enumerate(np.argsort(-w)):
    e[i] = v[val]
w = -np.sort(-w)
u = x @ e
a1 = x @ e[0]
a2 = x @ e[1]

# Plot
coef1 = np.polyfit(a1, a2, 1)
fn_pc1 = np.poly1d(coef1)

fig = plt.figure()
gs = GridSpec(2, 2)
ax1 = fig.add_subplot(gs[0, 0], xlim=[-15, 15], ylim=[-15, 15], xlabel='X1', ylabel='X2')
ax1.title.set_text('Centered data')
ax1.scatter(x[:, 0], x[:, 1], marker='.', linewidths=0.5)
ax1.plot(x[:, 0], fn_pc1(x[:, 0]), c='r')
ax1.plot(-fn_pc1(x[:, 0]), x[:, 0], c='k')
ax1.axhline(y=0, c='k')
ax1.axvline(x=0, c='k')
ax1.grid(True)

# remove outlier, index 16 & 157
x = np.delete(x, [16, 156], 0)

# Eigendecomposition
c = np.cov(x.T)
w, v = np.linalg.eig(c)
for i, val in enumerate(np.argsort(-w)):
    e[i] = v[val]
w = -np.sort(-w)
u_n = x @ e
a1 = x @ e[0]
a2 = x @ e[1]

# Plot
coef1 = np.polyfit(a1, a2, 1)
fn_pc1_n = np.poly1d(coef1)

ax2 = fig.add_subplot(gs[0, 1], xlim=[-15, 15], ylim=[-15, 15], xlabel='X1', ylabel='X2')
ax2.title.set_text('Centered Data w/o Outliers')
ax2.scatter(x[:, 0], x[:, 1], marker='.', linewidths=0.5)
ax2.plot(x[:, 0], fn_pc1(x[:, 0]), c='r')
ax2.plot(-fn_pc1(x[:, 0]), x[:, 0], c='k')
ax2.plot(x[:, 0], fn_pc1_n(x[:, 0]), c='r', linestyle='--', alpha=0.5)
ax2.plot(-fn_pc1_n(x[:, 0]), x[:, 0], c='k', linestyle='--', alpha=0.5)
ax2.axhline(y=0, c='k')
ax2.axvline(x=0, c='k')
ax2.grid(True)

ax3 = fig.add_subplot(gs[1, :], xlim=[-15, 15], ylim=[-15, 15], xlabel='PC1', ylabel='PC2')
ax3.title.set_text('Projection onto PCs')
ax3.scatter(u[:, 0], u[:, 1], marker='.', linewidths=0.5)
ax3.scatter(u_n[:, 0], u_n[:, 1], marker='.', linewidths=0.5, c='orange')
ax3.axhline(y=0, c='k')
ax3.axvline(x=0, c='k')
ax3.grid(True)

plt.show()
