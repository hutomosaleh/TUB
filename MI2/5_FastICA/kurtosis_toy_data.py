from scipy.io import loadmat
from copy import deepcopy
# from scipy.stats import kurtosis
import numpy as np
import matplotlib.pyplot as plt


def kurtosis(x):
    n = np.shape(x)[0]
    mean = np.sum((x**1) / n)
    var = np.sum((x-mean)**2) / n
    kurt = np.sum((x-mean)**4) / n
    kurt = kurt / (var**2) - 3
    return kurt


s = loadmat("Files/distrib.mat")
distribution_type = ['uniform', 'normal', 'laplacian']
A = np.array([[4, 3], [2, 1]])

# Mix source
x = dict()
for i in distribution_type:
    x[i] = (A @ s[i]).T

# Centering
for i in distribution_type:
    for j in range(np.shape(x[i])[1]):
        m = np.mean(x[i][:, j])
        x[i][:, j] = x[i][:, j] - m

# PCA
u = dict()
u_rot = dict()
for i in distribution_type:
    print(f"Start PCA for {i}")
    c = np.cov(x[i].T)
    w, v = np.linalg.eig(c)
    e = deepcopy(v)
    for j, val in enumerate(np.argsort(-w)):
        e[j] = v[val]
    w = -np.sort(-w)

    # Whitening
    u[i] = np.diag(1 / np.sqrt(w)) @ e.T @ x[i].T

    # Rotate
    theta_list = []
    k = []
    for theta in range(0, 180, 5):
        theta_list.append(np.deg2rad(theta))
        rotating_matrix = [[np.cos(theta), -np.sin(theta)], [np.sin(theta), np.cos(theta)]]
        u_rot[i] = rotating_matrix @ u[i]
        k1 = abs(kurtosis(u_rot[i][0, :]))
        k2 = abs(kurtosis(u_rot[i][1, :]))
        k.append(k1)
        # print(f"{i} / {k1=} / {k2=} / {theta=}")

    u_rot[i] = dict()
    i_max = k.index(max(k))
    theta = theta_list[i_max]
    rotating_matrix = [[np.cos(theta), -np.sin(theta)], [np.sin(theta), np.cos(theta)]]
    u_rot[i]['max'] = rotating_matrix @ u[i]
    print(f"Max: {np.rad2deg(theta)=}")
    i_min = k.index(min(k))
    theta = theta_list[i_min]
    rotating_matrix = [[np.cos(theta), -np.sin(theta)], [np.sin(theta), np.cos(theta)]]
    u_rot[i]['min'] = rotating_matrix @ u[i]
    print(f"Min: {np.rad2deg(theta)=}")




# Plot
for i, d in enumerate(distribution_type):
    s_plot = s[d].T
    x_plot = x[d]
    u_plot = u[d].T
    u_rot_max = u_rot[d]['max'].T
    u_rot_min = u_rot[d]['min'].T
    fig = plt.figure(i, constrained_layout=True)
    ax1 = fig.add_subplot(1, 1, 1, xlabel='S1', ylabel='S2')
    ax1.title.set_text(f'{d}')
    ax1.grid(True)
    ax1.scatter(s_plot[:, 0], s_plot[:, 1], c='blue', marker=".", label='source')
    ax1.scatter(x_plot[:, 0], x_plot[:, 1], c='green', marker=".", label='mixture')
    ax1.scatter(u_plot[:, 0], u_plot[:, 1], c='cyan', marker=".", label='whitened')
    ax1.scatter(u_rot_max[:, 0], u_rot_max[:, 1], c='red', marker=".", label='rotated')
    ax1.scatter(u_rot_min[:, 0], u_rot_min[:, 1], c='yellow', marker=".", label='rotated')
    ax1.axhline(y=0, color='k')
    ax1.axvline(x=0, color='k')
    ax1.legend()

plt.show()
print(x)
