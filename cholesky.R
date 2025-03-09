
# Define a positive definite matrix
m <- matrix(c(4, 12, -16, 12, 37, -43, -16, -43, 98), nrow = 3)

# Ensure the matrix is symmetric positive definite
m <- (m + t(m)) / 2

# Compute the Cholesky decomposition
U <- chol(m)

# Display the Cholesky factor U
print("Cholesky factor U:")
print(U)

# Verify the result
m_reconstructed <- t(U) %*% U

print("Reconstructed matrix (should be close to original m):")
print(m_reconstructed)