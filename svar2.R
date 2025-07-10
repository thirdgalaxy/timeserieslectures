# Author: Ozan Hatipoglu
#Synthethic SVAR
# Install and load necessary packages
if (!require(vars)) install.packages("vars")
if (!require(MASS)) install.packages("MASS")

library(vars)               ### Se cargan las librerías
library(forecast)
library(urca)
library(dplyr)

# Set seed for reproducibility
set.seed(123)

# Number of observations
n <- 1000

# Mean vector for X, Y, Z
mu <- c(X = 0, Y = 0, Z = 0)

# Covariance matrix
Sigma <- matrix(c(1, 0.1, 0.1,  # X with Y, Z
                  0.1, 1, 0.8,  # Y with Z
                  0.1, 0.8, 1), # Symmetric
                byrow = TRUE, nrow = 3)

# Simulate data
data <- mvrnorm(n = n, mu = mu, Sigma = Sigma)
colnames(data) <- c("X", "Y", "Z")
data_ts <- ts(data)  # Convert to time series object

# Fit a VAR model
var_model <- VAR(data_ts, p = 2)

# Impulse Response Analysis with Orthogonalized Shocks
irf_res <- irf(var_model, n.ahead = 10, ortho = TRUE)

# Plotting the impulse response
plot(irf_res)

