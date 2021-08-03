from copy import deepcopy
import numpy as np
import matplotlib.pyplot as plt

data = np.genfromtxt('Files/pca-data-2d.dat')  # Load dataset
x1_original = data[:, 0]
x2_original = data[:, 1]

# Center data
m = np.mean(x1_original)
x1 = x1_original - m
m = np.mean(x2_original)
x2 = x2_original - m
data = np.array([x1, x2])

# Plot
fig = plt.figure(constrained_layout=True)
ax1 = fig.add_subplot(2, 2, 1, xlim=[-3.5, 3.5], ylim=[-3.5, 3.5], xlabel='X1', ylabel='X2')
ax1.title.set_text('(a) the data')
ax1.grid(True)
ax1.scatter(x1, x2, c='orange', marker=".", label='Centered')  # Plot centered data
ax1.scatter(x1_original, x2_original, marker="x", label='Original')
ax1.axhline(y=0, color='k')
ax1.axvline(x=0, color='k')
ax1.legend()

# Calculate Projection
c = np.cov(data)
w, v = np.linalg.eig(c)
e = deepcopy(v)
for i, val in enumerate(np.argsort(-w)):  # order EV by highest EW
    e[i] = v[:, val]
w = -np.sort(-w)
u = (e @ data).T  # or np.matmul(e, data)
a1 = e[0] @ data
a2 = e[1] @ data

# Plot
ax2 = fig.add_subplot(2, 2, 2, xlim=[-2, 2], ylim=[-1.5, 1.5], xlabel='PC1', ylabel='PC2')
ax2.title.set_text('(b) centered data spanned by both PCs')
ax2.scatter(x[:, 0], x[:, 1], c='orange')
ax2.axhline(y=0, color='k')
ax2.axvline(x=0, color='k')
ax2.grid(True)

# Reconstruction of data
data_pc1 = u * e[0]  # I don't understand how to make this one
data_pc2 = u * e[1]
data_recon = (e.T @ u.T).T  # NANI?!

# Plot

ax3 = fig.add_subplot(2, 2, 3, xlim=[-1.5, 1.5], ylim=[-1.5, 1.5], xlabel='X1', ylabel='X2')
ax3.title.set_text('(c) Reconstructions')
ax3.scatter(x1, x2, c='orange', marker=".", label='centered data')  # Plot centered data
ax3.scatter(data_recon[:, 0], data_recon[:, 1], marker="x", label='reconstruction w/ all PCs')
ax3.axhline(y=0, color='k')
ax3.axvline(x=0, color='k')
ax3.grid(True)
ax3.legend()

plt.show()
