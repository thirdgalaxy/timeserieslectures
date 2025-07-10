# This R code demonstrates the SVD on a predefined matrix A 
# and reconstructs A using the product of U, Sigma, and the 
# transpose of V to verify the decomposition. SVD is 
# instrumentalin many data-driven applications, including 
# dimensionality reduction and noise reduction
# Define a matrix A
# Author: Ozan Hatipoglu
A <- matrix(c(1, 0, 0, 0, 2, 0, 0, 0, 3), nrow = 3)

# Perform Singular Value Decomposition
svd_decomp <- svd(A)

# Extract U, Sigma, and V matrices
U <- svd_decomp$u
Sigma <- diag(svd_decomp$d)
V <- svd_decomp$v

# Display the matrices
print("Orthogonal Matrix U:")
print(U)
print("Diagonal Matrix Sigma:")
print(Sigma)
print("Orthogonal Matrix V:")
print(V)

# Verify the result
A_reconstructed <- U %*% Sigma %*% t(V)
print("Reconstructed Matrix A (should match original):")
print(A_reconstructed)
