# Extended Kalman Filter With Regime-Shifting Signal Process
#uthor Ozan Hatipoglu 2024 Advanced Time Series LEctures 
# Install and load necessary packages
if (!requireNamespace("ggplot2", quietly = TRUE)) install.packages("ggplot2")
library(ggplot2)

# Simulation parameters
T <- 100  # Number of time steps
phi <- 0.9  # AR coefficient for x1
beta <- 0.1  # Constant term for x2
Q <- diag(c(0.01, 0.01))  # Process noise covariance matrix
R <- diag(c(0.1, 0.1))  # Observation noise covariance matrix
H <- diag(2)  # Observation matrix
x <- matrix(0, nrow = 2, ncol = T)  # True state
y <- matrix(0, nrow = 2, ncol = T)  # Observations

# Initial state
x[,1] <- c(0, 0)

# Generate true states and observations
set.seed(123)  # For reproducibility
for (t in 2:T) {
  alpha_t <- 0.5 + 0.05*sin(2*pi*t/T)  # Time-varying coefficient for x2
  x[,t] <- c(phi * x[1,t-1] + rnorm(1, sd = sqrt(Q[1,1])),
             alpha_t * x[2,t-1] + beta + rnorm(1, sd = sqrt(Q[2,2])))
  y[,t] <- H %*% x[,t] + matrix(rnorm(2, sd = sqrt(diag(R))), ncol = 1)
}

# EKF Initialization
xhat <- matrix(0, nrow = 2, ncol = T)  # State estimates
P <- array(0, c(2, 2, T))  # Covariance estimates
P[,,1] <- diag(2)  # Initial covariance estimate

# EKF Prediction and Update
for (t in 2:T) {
  alpha_t <- 0.5 + 0.05*sin(2*pi*t/T)  # Time-varying alpha for prediction
  A <- matrix(c(phi, 0, 0, alpha_t), nrow = 2)  # State transition matrix
  
  # Prediction
  xhat_pred <- A %*% xhat[,t-1]
  P_pred <- A %*% P[,,t-1] %*% t(A) + Q
  
  # Update
  K <- P_pred %*% t(H) %*% solve(H %*% P_pred %*% t(H) + R)
  xhat[,t] <- xhat_pred + K %*% (y[,t] - H %*% xhat_pred)
  P[,,t] <- (diag(2) - K %*% H) %*% P_pred
}

# Plotting the results
time <- 1:T
data <- data.frame(Time = rep(time, 4),
                   State = c(x[1,], xhat[1,], x[2,], xhat[2,]),
                   Type = rep(c("True x1", "Estimated x1", "True x2", "Estimated x2"), each = T))

ggplot(data, aes(x = Time, y = State, color = Type)) + geom_line() +
  theme_minimal() + labs(title = "EKF State Estimation", y = "State value", x = "Time")

