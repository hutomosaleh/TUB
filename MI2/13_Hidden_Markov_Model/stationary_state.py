import numpy as np

# Define transition matrix
A = np.array([[0.2, 0.6, 0.2],
              [0.3, 0. , 0.7],
              [0.5, 0. , 0.5]])

# Calculate Eigenvectors & -values
w, v = np.linalg.eig(A.T)  #  Transposed so Markov transitions correspond to right multiplying by a column vector

# Get Eigenvector that corresponds to lambda = 1
v1 = v[:, np.isclose(w, 1)]

# Format to proper vector
v1 = v1[:, 0]

# Normalize
v1 = v1 / v1.sum()

# Get real value
v1 = v1.real

print(v1)