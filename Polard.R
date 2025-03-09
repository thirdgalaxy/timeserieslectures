# Implementing Polar Decomposition in R can be achieved using the SVD
# In this R code, the svd() function is used to perform the SVD of matrix A. 
# The unitary and positive semi-definite matrices of the Polar Decomposition 
# (U and P, respectively) are then derived from the SVD components and used 
# to reconstruct A for verification. This approach 
# demonstrates the practical application of Polar Decomposition in numerical 
# linear algebra.


# Define a matrix A
A <- matrix(c(3, 4, -1, 2, 0, -3), nrow = 2, byrow = TRUE)

# Perform Singular Value Decomposition (SVD)
svd_decomp <- svd(A)

# Extract the SVD components
V <- svd_decomp$v
Sigma <- diag(svd_decomp$d)
U_svd <- svd_decomp$u

# Compute the Polar Decomposition components
U <- U_svd %*% t(V)
P <- V %*% Sigma %*% t(V)

# Display the matrices
print("Unitary Matrix U:")
print(U)
print("Positive Semi-Definite Matrix P:")
print(P)

# Verify the result
A_reconstructed <- U %*% P
print("Reconstructed Matrix A (should match original):")
print(A_reconstructed)
