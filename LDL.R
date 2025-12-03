# Ozan Hatipoglu LDL Decomposition is a version of the Cholesky decomposition 
# that is used for symmetric, but not necessarily positive 
# definite, matrices. 
# In this R code, the ldl() function is used to decompose a symmetric
# matrix A into L and D. The original matrix is then reconstructed to 
# verify the decomposition. Note 
# that the Matrix package needs to be installed and loaded for this code to work.
# Ensure the 'Matrix' package is installed and loaded
if (!require(Matrix)) install.packages("Matrix")
library(Matrix)

# Symmetric positive definite matrix
A <- matrix(c(4, -2,  2,
              -2, 2, -1,
              2, -1, 3),
            nrow = 3, byrow = TRUE)

# Cholesky: A = R^T R, R upper triangular
R_chol <- chol(A)

# Convert to a lower-triangular factor L_chol so that A = L_chol L_chol^T
L_chol <- t(R_chol)

# Extract diagonal entries
d  <- diag(L_chol)

# Build unit lower-triangular L and diagonal D such that A = L D L^T
L <- L_chol
for (j in seq_along(d)) {
  L[, j] <- L[, j] / d[j]   # divide each column j by d[j]
}
D <- diag(d^2)

cat("Lower triangular L (unit diagonal):\n")
print(L)
cat("Diagonal D:\n")
print(D)

# Verify A = L D L^T
A_reconstructed <- L %*% D %*% t(L)

cat("Original A:\n")
print(A)
cat("Reconstructed A (L D L^T):\n")
print(A_reconstructed)