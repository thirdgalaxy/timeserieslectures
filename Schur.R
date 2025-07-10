# Author: Ozan Hatipoglu This R code demonstrates the Schur decomposition on a predefined matrix 
# A and reconstructs A using the product of the resulting Q and T 
# matrices to verify the decomposition. Schur decomposition is an 
# essential tool in numerical linear 
# algebra for handling eigenvalue-related problems.


# Ensure the 'Matrix' package is installed and loaded
if (!require(Matrix)) install.packages("Matrix")
library(Matrix)

# Define a matrix A
A <- matrix(c(1, 2, 3, 4, 5, 6, 7, 8, 9), nrow = 3)

# Perform Schur decomposition
schur_decomp <- Schur(A)

# Extract Q and T matrices
Q <- schur_decomp$Q
T <- schur_decomp$T

# Display the matrices
print("Unitary Matrix Q:")
print(Q)
print("Upper Triangular Matrix T:")
print(T)

# Verify the result
A_reconstructed <- Q %*% T %*% t(Q)
print("Reconstructed Matrix A (should match original):")
print(A_reconstructed)
