# Ozan Hatipoglu This assumes A is symmetric positive definite. It computes
#A = L D L^\top with:
#L unit lower-triangular,
#D diagonal. No package needed. April 2023. 
#Custom LDL decomposition (SPD case, no pivoting)
ldl_decomp <- function(A, tol = 1e-12) {
  A <- as.matrix(A)
  n <- nrow(A)
  if (ncol(A) != n) stop("A must be square")
  
  L <- diag(1, n)
  d <- numeric(n)
  
  for (j in 1:n) {
    if (j == 1) {
      d[j] <- A[j, j]
    } else {
      d[j] <- A[j, j] - sum((L[j, 1:(j - 1)]^2) * d[1:(j - 1)])
    }
    
    if (abs(d[j]) < tol) {
      stop("Matrix is not positive definite or pivot too small at step ", j)
    }
    
    if (j < n) {
      for (i in (j + 1):n) {
        if (j == 1) {
          L[i, j] <- A[i, j] / d[j]
        } else {
          L[i, j] <- (A[i, j] -
                        sum(L[i, 1:(j - 1)] * L[j, 1:(j - 1)] * d[1:(j - 1)])) / d[j]
        }
      }
    }
  }
  
  D <- diag(d)
  list(L = L, D = D)
}



# Symmetric matrix A
A <- matrix(c(4, -2,  2,
              -2, 2, -1,
              2, -1, 3),
            nrow = 3, byrow = TRUE)

# LDL decomposition
ldl_res <- ldl_decomp(A)
L <- ldl_res$L
D <- ldl_res$D

cat("Lower triangular L:\n"); print(L)
cat("Diagonal D:\n"); print(D)

# Verify A = L D L^T
A_reconstructed <- L %*% D %*% t(L)

cat("Original A:\n"); print(A)
cat("Reconstructed A (L D L^T):\n"); print(A_reconstructed)