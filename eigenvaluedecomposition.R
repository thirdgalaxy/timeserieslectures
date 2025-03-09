# This R code demonstrates the eigenvalue decomposition of a 
# predefined matrix A, extracting its eigenvectors and eigenvalues, 
# and then reconstructing A to verify the decomposition. 

# Define a matrix A
A <- matrix(c(4, 0, 2, 3, 3, 0, 0, 0, 1), nrow = 3, byrow = TRUE)

# Perform Eigenvalue Decomposition
eigen_decomp <- eigen(A)

# Extract P (eigenvectors) and D (eigenvalues)
P <- eigen_decomp$vectors
D <- diag(eigen_decomp$values)

# Display the matrices
print("Matrix P (eigenvectors):")
print(P)
print("Diagonal Matrix D (eigenvalues):")
print(D)

# Verify the result
A_reconstructed <- P %*% D %*% solve(P)
print("Reconstructed Matrix A (should match original):")
print(A_reconstructed)
