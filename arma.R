library(stats)
library(ggplot2)

# Simulate time series data
n <- 10000
set.seed(123)

ar1_data <- arima.sim(model = list(ar = 0.5), n = n)
ar2_data <- arima.sim(model = list(ar = c(0.5, -0.25)), n = n)
ma1_data <- arima.sim(model = list(ma = 0.5), n = n)
ma2_data <- arima.sim(model = list(ma = c(0.5, 0.25)), n = n)

# Approximate an MA(inf) and AR(inf) as high-order MA and AR
ma_inf_data <- arima.sim(model = list(ma = rep(0.5, 10)), n = n)
ar_inf_data <- arima.sim(model = list(ar = rep(-0.5, 10)), n = n)

# Compute ACF for each series
acf_ar1 <- acf(ar1_data, plot = FALSE)
acf_ar2 <- acf(ar2_data, plot = FALSE)
acf_ma1 <- acf(ma1_data, plot = FALSE)
acf_ma2 <- acf(ma2_data, plot = FALSE)
acf_ma_inf <- acf(ma_inf_data, plot = FALSE)
acf_ar_inf <- acf(ar_inf_data, plot = FALSE)

# Create a combined data frame for plotting
combined_df <- data.frame(
  lag = rep(acf_ar1$lag, 6),
  acf = c(acf_ar1$acf, acf_ar2$acf, acf_ma1$acf, acf_ma2$acf, acf_ma_inf$acf, acf_ar_inf$acf),
  type = rep(c("AR(1)", "AR(2)", "MA(1)", "MA(2)", "MA(Inf)", "AR(Inf)"), each = length(acf_ar1$lag))
)

# Plot using ggplot2
ggplot(combined_df, aes(x = lag, y = acf, color = type)) +
  geom_line() +
  labs(title = "ACF of AR and MA Processes", x = "Lag", y = "ACF") +
  theme_minimal()

