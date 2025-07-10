# AUTHOR: OZAN HATIPOGLU - ADVANCED TIME SERIES LECTURE NOTES
# Extended Kalman Filter with Time Variable  Parameters
set.seed(123)  # For reproducibility
T <- 100  # Number of time steps
phi <- 0.9  # AR coefficient for x1
beta <- 0.1  # Constant term for influence on x2

# Simulate x1 as an AR(1) process
x1 <- stats::filter(rnorm(T), filter = phi, method = "recursive")

# Simulate alpha as a random walk
alpha_true <- cumsum(rnorm(T, sd = 0.02))  # True alpha values
alpha_true <- c(0.5, alpha_true[-T])  # Assuming initial alpha is 0.5

# Simulate x2 influenced by alpha and x1
x2 <- beta + alpha_true * x1 + rnorm(T, sd = sqrt(0.1))

# Simulate observations with noise
y <- x1 + rnorm(T, sd = 0.1)  # Observation for x1
y2 <- x2 + rnorm(T, sd = 0.1)  # Observation for x2, assuming direct observation

# EKF Initialization
xhat <- matrix(0, nrow = 3, ncol = T)  # State estimates (x1, x2, alpha)
P <- array(0, c(3, 3, T))  # Covariance estimates
P[,,1] <- diag(c(1, 1, 1))  # Initial covariance estimate
Q <- diag(c(0.01, 0.01, 0.0004))  # Process noise covariance (including alpha)
R <- 0.1  # Observation noise covariance (assuming same for simplicity)

# Observation matrix (assuming direct observation of x1 and x2)
H <- matrix(c(1,0,0, 0,1,0), nrow = 2, byrow = TRUE)

# EKF Process
for (t in 2:T) {
  # State transition matrix A
  A <- matrix(c(1, 0, 0,
                0, 1, xhat[1,t-1],
                0, 0, 1), nrow = 3, byrow = TRUE)
  
  # Prediction
  xhat_pred <- A %*% xhat[,t-1]
  P_pred <- A %*% P[,,t-1] %*% t(A) + Q
  
  # Observation update
  y_t <- c(y[t], y2[t])  # Current observations
  K <- P_pred %*% t(H) %*% solve(H %*% P_pred %*% t(H) + diag(c(R, R)))
  xhat[,t] <- xhat_pred + K %*% (y_t - H %*% xhat_pred)
  P[,,t] <- (diag(3) - K %*% H) %*% P_pred
}

# Visualization
time <- 1:T
plot(time, alpha_true, type='l', col='blue', ylim=range(c(alpha_true, xhat[3,])), ylab='Alpha', xlab='Time', main='True vs Estimated Alpha')
lines(time, xhat[3,], col='red')
legend('topright', legend=c('True Alpha', 'Estimated Alpha'), col=c('blue', 'red'), lty=1)
