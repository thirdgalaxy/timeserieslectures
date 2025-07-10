# Load necessary library
install.packages("dlm")
library(dlm)

# Simulate a time series with AR(1) state process
set.seed(123)
n <- 100
phi <- 0.8
mu <- numeric(n)
mu[1] <- rnorm(1, 0, 1)
for (t in 2:n) {
  mu[t] <- phi * mu[t-1] + rnorm(1, 0, 0.5)
}
y <- mu + rnorm(n, 0, 1) # Observed series

# Define the model with AR(1) state process
mod <- dlmModARMA(ar = phi, sigma2 = 0.5^2, dV = 1)

# Kalman filter
kf <- dlmFilter(y, mod)

# Extract the estimated state
mu_hat <- dropFirst(kf$m)

# Plot the original series and the estimated state
plot(y, type = "l", col = "blue", ylim = range(c(y, mu_hat)), ylab = "Value", main = "Kalman Filter with AR(1) State Process")
lines(mu_hat, col = "red", lty = 2)
legend("topright", legend = c("Observed Series", "Estimated State"), col = c("blue", "red"), lty = c(1, 2))
