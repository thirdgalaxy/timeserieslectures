# Load required packages
library(quantmod)
library(ggplot2)

# --- BN decomposition for AR(2) I(1) process ---
bn_decomposition_ar2 <- function(series, H = 100) {
  if (!is.ts(series)) series <- ts(series)
  
  # Fit AR(2) model (no differencing)
  ar_model <- ar(series, aic = FALSE, order.max = 2, method = "yw")
  phi <- ar_model$ar
  intercept <- ifelse("x.mean" %in% names(ar_model), ar_model$x.mean * (1 - sum(phi)), 0)
  
  # Compute residuals manually
  T <- length(series)
  residuals <- rep(NA, T)
  for (t in 3:T) {
    y_hat <- intercept + phi[1] * series[t - 1] + phi[2] * series[t - 2]
    residuals[t] <- series[t] - y_hat
  }
  
  # Invert AR(2) to get MA(∞) representation
  psi_weights <- ARMAtoMA(ar = phi, ma = numeric(0), lag.max = H)
  
  # Compute BN trend: y_t - sum_{j=1}^H psi_j * epsilon_{t-j}
  trend <- rep(NA, T)
  for (t in (H + 3):T) {
    adjustment <- sum(psi_weights[1:H] * residuals[(t - 1):(t - H)])
    trend[t] <- series[t] - adjustment
  }
  
  # Output aligned components
  valid_idx <- which(!is.na(trend))
  trend_ts <- ts(trend[valid_idx], start = time(series)[valid_idx[1]], frequency = frequency(series))
  y_trimmed <- window(series, start = start(trend_ts))
  cycle <- y_trimmed - trend_ts
  
  return(list(y = y_trimmed, trend = trend_ts, cycle = cycle, ar_coef = phi))
}


# Simulate AR(2) process with unit root
set.seed(123)
n <- 300
phi1 <- 1.2
phi2 <- -0.4
eps <- rnorm(n)
y <- numeric(n)
y[1:2] <- eps[1:2]
for (t in 3:n) {
  y[t] <- phi1 * y[t-1] + phi2 * y[t-2] + eps[t]
}
y_ts <- ts(y)

# Apply BN decomposition
bn_sim <- bn_decomposition_ar2(y_ts)

# Plot
df_sim <- data.frame(
  Time = time(bn_sim$y),
  y = as.numeric(bn_sim$y),
  Trend = as.numeric(bn_sim$trend),
  Cycle = as.numeric(bn_sim$cycle)
)

ggplot(df_sim, aes(x = Time)) +
  geom_line(aes(y = y, color = "Original")) +
  geom_line(aes(y = Trend, color = "Trend")) +
  geom_line(aes(y = Cycle, color = "Cycle")) +
  labs(title = "Beveridge-Nelson Decomposition of Simulated AR(2)",
       y = "Value", color = "Component") +
  theme_minimal()


# Download AAPL data
getSymbols("AAPL", from = "2010-01-01", to = "2025-01-01", auto.assign = TRUE)
log_prices <- log(Cl(AAPL))
log_prices <- na.omit(log_prices)

# Apply BN decomposition
bn_aapl <- bn_decomposition_ar2(log_prices)

# Plot
df_aapl <- data.frame(
  Date = index(bn_aapl$y),
  LogPrice = as.numeric(bn_aapl$y),
  Trend = as.numeric(bn_aapl$trend),
  Cycle = as.numeric(bn_aapl$cycle)
)

ggplot(df_aapl, aes(x = Date)) +
  geom_line(aes(y = LogPrice, color = "Log Price")) +
  geom_line(aes(y = Trend, color = "BN Trend")) +
  geom_line(aes(y = Cycle, color = "Cycle")) +
  labs(title = "Beveridge-Nelson Decomposition of AAPL Log Prices",
       y = "Log Price", color = "Component") +
  theme_minimal()
