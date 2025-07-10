# AUTHOR: OZAN HATIPOGLU - ADVANCED TIME SERIES LECTURE NOTES

# The Extended Kalman Filter is a nonlinear version of the Kalman Filter which linearizes 
# about an estimate of the current mean and covariance. Implementing an EKF with variable 
# coefficients means that the system model or observation model will have parameters that
# change over time.

# Here's an outline of the steps I'll take in the R code:
#   
#   Define the state and observation models, incorporating time-varying coefficients.
# Initialize the state, covariance, and any necessary parameters for the filter.
# Implement the prediction step, where we'll use the state model to predict the next state
# and update the covariance.
# Implement the update step, where we'll incorporate new observations to update the state
# estimate and refine the covariance using the Kalman gain.
# The R code below implements these steps:

# This example demonstrates a very basic framework for implementing an EKF 
# with variable coefficients in R. You should modify the getSystemMatrices 
# # function to match the dynamics of your specific system and ensure that 
# # the observation data y is correctly formatted for your problem.
# In the context of the Extended Kalman Filter (EKF) implementation provided earlier, 
# the observation vector y is expected to be a matrix where each column represents 
# an observation at a time step, and each row represents a different observed variable.
# For a system with a single observed variable over time, y would be a matrix with a single 
# row and as many columns as there are time steps in your observations.
# 
# Here's how to format the y variable correctly:
# 
# Single Observed Variable: If your system has only one observed variable, y 
# should bea 1-row matrix, where each column is the observation at a given 
# time step. 
# For example, if you have 10 observations over time, y would look like this:
# y <- matrix(c(y1, y2, y3, ..., y10), nrow = 1)


# In both cases, the observations are ordered chronologically, so the first column of y 
# is the first set of observations, the second column the second set, and so on.
# # 
# # Example for a Single Observed Variable
# # over 5 days, your y matrix could look like this:
# # Example temperature readings over 5 days
#   temperature_readings <- c(20.1, 21.5, 19.8, 22.2, 20.0)  # Example values
# y <- matrix(temperature_readings, nrow = 1)  # Format as a 1-row matrix


# 
# # Multiple Observed Variables: If your system observes more than one variable at each
# # time step, y should have as many rows as there are variables, with each column 
# # still representing a time step. For a system with 2 observed variables over
# # 10 time steps, y would be structured as:
# Example for Multiple Observed Variables
# If your system measures both temperature and humidity over 5 days, with a row for each variable:
# #y <- matrix(c(y1_var1, y2_var1, y3_var1, ..., y10_var1,
#               y1_var2, y2_var2, y3_var2, ..., y10_var2), nrow = 2)
#  
# 
# # Example temperature and humidity readings over 5 days
# temperature_readings <- c(20.1, 21.5, 19.8, 22.2, 20.0)  # Temperature values
# humidity_readings <- c(55, 60, 58, 62, 57)  # Humidity values
# 
# # Combine into a matrix with 2 rows (variables) and 5 columns (time steps)
# y <- matrix(c(temperature_readings, humidity_readings), nrow = 2)
# 



# Install necessary packages if not already installed
if (!requireNamespace("FKF", quietly = TRUE)) install.packages("FKF")

# Load the FKF package
library(FKF)

# Define the system dynamics for the EKF
# This function should return the state transition matrix and observation 
# matrix, which may change over time
getSystemMatrices <- function(t, params) {
  # Example: simple system with variable coefficients
  # Replace with your actual system dynamics
  A <- matrix(c(cos(params$a * t), -sin(params$a * t), sin(params$a * t), 
  cos(params$a * t)), nrow = 2)
  H <- matrix(c(1, 0), nrow = 1)
  
  return(list(A = A, H = H))
}

# Extended Kalman Filter (EKF) with variable coefficients
EKF <- function(y, x0, P0, Q, R, params) {
  n <- ncol(y)
  m <- length(x0)
  
  # Allocate space for results
  xhat <- matrix(0, nrow = m, ncol = n)
  P <- array(0, dim = c(m, m, n))
  
  # Initialize state and covariance estimates
  xhat[,1] <- x0
  P[,,1] <- P0
  
  for (t in 2:n) {
    # Get system matrices for current time step
    matrices <- getSystemMatrices(t, params)
    A <- matrices$A
    H <- matrices$H
    
    # Prediction step
    xhat_minus <- A %*% xhat[,t-1]
    P_minus <- A %*% P[,,t-1] %*% t(A) + Q
    
    # Update step
    K <- P_minus %*% t(H) %*% solve(H %*% P_minus %*% t(H) + R)
    xhat[,t] <- xhat_minus + K %*% (y[,t] - H %*% xhat_minus)
    P[,,t] <- (diag(m) - K %*% H) %*% P_minus
  }
  
  return(list(xhat = xhat, P = P))
}

# Example usage
# Define initial conditions
x0 <- c(1, 0) # Initial state
P0 <- diag(2) # Initial covariance
Q <- diag(c(0.1, 0.1)) # Process noise covariance
R <- matrix(0.1) # Measurement noise covariance
params <- list(a = 0.1) # Example parameter for system dynamics

# Simulated observation data
# Replace with your actual data
y <- matrix(rnorm(20), nrow = 1)

# Run EKF
results <- EKF(y, x0, P0, Q, R, params)

# Extract and plot results
xhat <- results$xhat
plot(t(xhat[1,]), type = 'l', col = 'blue', ylim = range(xhat), ylab = 'State Estimates', xlab = 'Time', main = 'Extended Kalman Filter Estimates')
lines(t(xhat[2,]), col = 'red')
legend('topright', legend = c('State 1', 'State 2'), col = c('blue', 'red'), lty = 1)
