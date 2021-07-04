from copy import deepcopy
import numpy as np
import matplotlib.pyplot as plt

data = np.loadtxt('Files/pca-data-3d.txt', delimiter=',', skiprows=1)
x1 = data[:, 0]
x2 = data[:, 1]
x3 = data[:, 1]

# Centering
m = np.mean(x1)
x1 = x1 - m
m = np.mean(x2)
x2 = x2 - m
m = np.mean(x2)
x3 = x3 - m
data = np.array([x1, x2, x3]).T

# Plot
fig = plt.figure()
ax1 = fig.add_subplot(3, 3, 1, projection='3d')
ax1.title.set_text('Scatter Plot of Centered Data')
ax1.set_xlabel('X1')
ax1.set_ylabel('X2')
ax1.set_zlabel('X3')
ax1.scatter(x1, x2, x3, marker='o')

# Calculate Projection
c = np.cov(data.T)
w, v = np.linalg.eig(c)
e = deepcopy(v)
for i, val in enumerate(np.argsort(-w)):
    e[i] = v[val]
w = -np.sort(-w)
y_pc1 = np.matmul(data, e[0])
y_pc2 = np.matmul(data, e[1])
y_pc3 = np.matmul(data, e[2])

# Plot
ax2 = fig.add_subplot(232, projection='3d')
ax2.title.set_text('Scatter Plot of projected data')
ax2.set_xlabel('PC1')
ax2.set_ylabel('PC2')
ax2.set_zlabel('PC3')
ax2.scatter(y_pc1, y_pc2, y_pc3, marker='^')

# Reconstruction of data
data_pc1 = deepcopy(data)
data_pc2 = deepcopy(data)
data_pc3 = deepcopy(data)
for i, val in enumerate(data):
    data_pc1[i] = np.matmul(e[0].T, data[i]) * e[0]
    data_pc2[i] = np.matmul(e[1].T, data[i]) * e[1]
    data_pc3[i] = np.matmul(e[2].T, data[i]) * e[2]

# Plot
ax3 = fig.add_subplot(234, projection='3d')
ax3.title.set_text('Reconstruction with only PC1')
ax3.set_xlabel('X1')
ax3.set_ylabel('X2')
ax3.set_zlabel('X3')
ax3.scatter(data_pc1[:, 0], data_pc1[:, 1], data_pc1[:, 2])

ax4 = fig.add_subplot(235, projection='3d')
ax4.title.set_text('Reconstruction with only PC2')
ax4.set_xlabel('X1')
ax4.set_ylabel('X2')
ax4.set_zlabel('X3')
ax4.scatter(data_pc2[:, 0], data_pc2[:, 1], data_pc2[:, 2])

ax5 = fig.add_subplot(236, projection='3d')
ax5.title.set_text('Reconstruction with only PC3')
ax5.set_xlabel('X1')
ax5.set_ylabel('X2')
ax5.set_zlabel('X3')
ax5.scatter(data_pc2[:, 0], data_pc2[:, 1], data_pc3[:, 2])

plt.show()
