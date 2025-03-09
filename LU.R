# # This R code performs the LU decomposition on a predefined matrix A and
# then reconstructs A using the product of the resulting L and U matrices 
# to verify the decomposition.

# Ensure the 'Matrix' package is installed and loaded
if (!require(Matrix)) install.packages("Matrix")
library(Matrix)

# Define a matrix A
A <- matrix(c(4, 3, 2, 1, 2, 2, 3, 4, 1, 3, 4, 4), nrow = 3, byrow = TRUE)

# Perform LU decomposition
lu_decomp <- lu(as(A, "CsparseMatrix"))

# Extract L and U matrices
L <- as(lu_decomp$L, "matrix")
U <- as(lu_decomp$U, "matrix")

# Display the matrices
print("Lower Triangular Matrix L:")
print(L)
print("Upper Triangular Matrix U:")
print(U)

# Verify the result
A_reconstructed <- L %*% U
print("Reconstructed Matrix A (should match original):")
print(A_reconstructed)
