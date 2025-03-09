# LDL Decomposition is a variant of the Cholesky decomposition 
# that is used forsymmetric, but not necessarily positive 
# definite, matrices. 
# In this R code, the ldl() function is used to decompose a symmetric
# matrix A into L and D. The original matrix is then reconstructed to 
# verify the decomposition. Note 
# that the Matrix package needs to be installed and loaded for this code to work.
# Ensure the 'Matrix' package is installed and loaded
if (!require(Matrix)) install.packages("Matrix")
library(Matrix)

# Define a symmetric matrix A
A <- matrix(c(4, -2, 2, -2, 2, -1, 2, -1, 3), nrow = 3, byrow = TRUE)

# Perform LDL decomposition
ldl_decomp <- ldl(A)

# Extract L and D matrices
L <- ldl_decomp$L
D <- ldl_decomp$D

# Display the matrices
print("Lower Triangular Matrix L:")
print(L)
print("Diagonal Matrix D:")
print(D)

# Verify the result
A_reconstructed <- L %*% D %*% t(L)
print("Reconstructed Matrix A (should match original):")
print(A_reconstructed)
