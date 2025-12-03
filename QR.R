# Author: Ozan Hatipoglu - Advanced Time Series LEcture Notes
# This R code performs the QR decomposition on a predefined matrix A
# and then reconstructs A using the product of the resulting Q and 
# R matrices to verify the decomposition. QR decomposition is 
# especially useful in numerical methods for solving 
# linear systems and least squares problems.


# Define a matrix A
A <- matrix(c(12, -51, 4, 6, 167, -68, -4, 24, -41), nrow = 3, byrow = TRUE)

# Perform QR decomposition
qr_decomp <- qr(A)

# Extract Q and R matrices
Q <- qr.Q(qr_decomp)
R <- qr.R(qr_decomp)

# Display the matrices
print("Orthogonal Matrix Q:")
print(Q)
print("Upper Triangular Matrix R:")
print(R)

# Verify the result
A_reconstructed <- Q %*% R
print("Reconstructed Matrix A (should match original):")
print(A)
print(A_reconstructed)
