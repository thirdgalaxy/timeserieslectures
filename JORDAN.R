# This R code provides an approximation of the Jordan Decomposition for 
# diagonalizable matrices. For non-diagonalizable matrices, the process is more 
# complex and typically requires specialized mathematical software capable of handling generalized 
# eigenvectors and Jordan blocks.

# Define a matrix A
A <- matrix(c(4, -5, 2, 1, 1, 1, 1, 2, 3), nrow = 3)

# Perform Eigenvalue Decomposition (as an approximation for Jordan Decomposition)
eigen_decomp <- eigen(A)

# Extract P (eigenvectors) and D (eigenvalues)
P <- eigen_decomp$vectors
D <- diag(eigen_decomp$values)

# Display the matrices
print("Matrix P (approximated generalized eigenvectors):")
print(P)
print("Diagonal Matrix D (approximated Jordan form):")
print(D)

# Verify the result
A_reconstructed <- P %*% D %*% solve(P)
print("Reconstructed Matrix A (should match original):")
print(A_reconstructed)
