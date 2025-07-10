# AUTHOR: OZAN HATIPOGLU - ADVANCED TIME SERIES LECTURE NOTES
# Extended Kalman Filter
set.seed(123) # For reproducibility
T <- 100 # Number of time steps
phi <- 0.9 # AR coefficient for x1

# Correctly generate AR(1) process for x1 using base R filter function
x1 <- stats::filter(rnorm(T, sd = sqrt(0.1)), phi, method = "recursive") 

alpha <- cumsum(rnorm(T, sd = sqrt(0.02))) # Random walk for alpha
# Ensure x2 is calculated correctly by adjusting dimensions
x2 <- 0.1 + alpha[-T] * x1[-length(x1)] + rnorm(T-1, sd = sqrt(0.1)) 
x2 <- c(0, x2) # Prepend initial value to align dimensions if necessary

# Construct observations with noise for both x1 and x2
y <- rbind(x1 + rnorm(T, sd = 0.1), x2 + rnorm(T, sd = 0.1))

# Placeholder for EKF implementation - the rest of the implementation would follow as before

# Note: Ensure the rest of your EKF implementation and data handling logic accounts for the corrected x1 and x2 dimensions


# Initialize
xhat <- matrix(0, nrow = 3, ncol = T) # State estimates
P <- array(0, dim = c(3, 3, T)) # Covariance estimates
P[,,1] <- diag(3) # Initial covariance estimate
Q <- diag(c(0.1, 0.1, 0.02)) # Process noise covariance
R <- diag(2) * 0.1 # Observation noise covariance
H <- matrix(c(1,0,0, 0,1,0), nrow = 2, byrow = TRUE) # Observation matrix

# EKF
for (t in 2:T) {
  # Prediction
  A <- matrix(c(1,0,0, 0,1,xhat[1,t-1], 0,0,1), nrow = 3) # State transition matrix
  xhat_pred <- A %*% xhat[,t-1]
  P_pred <- A %*% P[,,t-1] %*% t(A) + Q
  
  # Update
  K <- P_pred %*% t(H) %*% solve(H %*% P_pred %*% t(H) + R)
  xhat[,t] <- xhat_pred + K %*% (y[,t] - H %*% xhat_pred)
  P[,,t] <- (diag(3) - K %*% H) %*% P_pred
}

# Visualization
plot(x1, type = 'l', col = 'blue', ylim = range(c(xhat[1,], x1)), ylab = 'State', xlab = 'Time')
lines(xhat[1,], col = 'red')
legend('bottomleft', legend = c('True x1', 'Estimated x1'), col = c('blue', 'red'), lty = 1)
