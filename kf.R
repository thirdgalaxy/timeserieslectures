# Load necessary library
if (!require("dlm")) install.packages("dlm", dependencies=TRUE)
library(dlm)

# Simulate a non-stationary time series with trend component
set.seed(123)
n <- 100
mu <- cumsum(rnorm(n, 0, 0.5)) # True trend
y <- mu + rnorm(n, 0, 1) # Observed series

# Define the model
mod <- dlmModPoly(order = 1, dV = 1, dW = 0.5^2)

# Kalman filter
kf <- dlmFilter(y, mod)

# Extract the estimated state
mu_hat <- dropFirst(kf$m)

# Plot the original series and the estimated state
plot(y, type = "l", col = "blue", ylim = range(c(y, mu_hat)), ylab = "Value", main = "State Space Methods: Kalman Filter")
lines(mu_hat, col = "red", lty = 2)
legend("topright", legend = c("Observed Series", "Estimated State"), col = c("blue", "red"), lty = c(1, 2))

# Add a legend
legend("topright", legend = c("Observed Series", "Estimated State"), col = c("blue", "red"), lty = c(1, 2))

