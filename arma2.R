library(stats)

# Parameters
n <- 10000
ar1_coeff <- 0.5
ar2_coeff <- c(0.5, -0.25)
ma1_coeff <- 0.5
ma2_coeff <- c(0.5, 0.25)
lag_max <- 30
line_width <- 2
label_pos <- c(25, 0.8) # Adjust label position as needed

# Simulate time series data
set.seed(123)
ar1_data <- arima.sim(n = n, model = list(ar = ar1_coeff))
ar2_data <- arima.sim(n = n, model = list(ar = ar2_coeff))
ma1_data <- arima.sim(n = n, model = list(ma = ma1_coeff))
ma2_data <- arima.sim(n = n, model = list(ma = ma2_coeff))

# Set up plotting area
par(mfrow = c(4, 2), mar = c(4, 4, 2, 1))

# Function to plot ACF, PACF and add label
plot_acf_pacf <- function(data, model_label) {
  acf(data, main = "", lag.max = lag_max, lwd = line_width)
  text(label_pos[1], label_pos[2], model_label, cex = 1)
  pacf(data, main = "", lag.max = lag_max, lwd = line_width)
  text(label_pos[1], label_pos[2], model_label, cex = 1)
}

# ACF and PACF for AR(1)
plot_acf_pacf(ar1_data, "AR(1)")

# ACF and PACF for AR(2)
plot_acf_pacf(ar2_data, "AR(2)")

# ACF and PACF for MA(1)
plot_acf_pacf(ma1_data, "MA(1)")

# ACF and PACF for MA(2)
plot_acf_pacf(ma2_data, "MA(2)")
