# Ensure the necessary libraries are installed and loaded
if (!require('forecast')) install.packages('forecast')
if (!require('ggplot2')) install.packages('ggplot2')

library(forecast)
library(ggplot2)


# Set seed for reproducibility
set.seed(123)

# Number of observations
n <- 1000 

# Simulate an ARIMA(2,1,1) series
arima_series <- arima.sim(n = n, model = list(order = c(2, 1, 1), ar = c(0.5, -0.3), ma = c(0.4)))

# Convert the simulated series into a time series object
arima_ts <- ts(arima_series)

# Fit an ARIMA(2,1,1) model to the simulated series
fit <- Arima(arima_series, order=c(2,1,1))


# Create an extended time series to include both historical and forecast periods
extended_series <- ts(c(arima_series, rep(NA, length(forecasts$mean))), start=1)

# Fill in the forecasted values at the end of the extended series
extended_series[(n+1):(n+length(forecasts$mean))] <- forecasts$mean

# Adjust the window size as needed; here, using a small window for demonstration
window_size <- 25
trend_approx <- stats::filter(extended_series, rep(1/window_size, window_size), sides=2)

# Plotting the original series with the approximated trend
plot(extended_series, main="ARIMA(2,1,1) Series with Approximated Trend", ylab="Value", col="grey", type="l")
lines(trend_approx, col="blue", lwd=2)
legend("topleft", legend=c("Extended Series", "Approximated Trend"), col=c("grey", "blue"), lty=1, lwd=2)


# Assuming 'arima_series', 'fit', and 'forecasts' are defined as before

# Calculate the trend approximation over the entire series again for clarity
window_size <- 25 # Moving average window size
trend_approx <- stats::filter(extended_series, rep(1/window_size, window_size), sides=2)

# Calculate the cycle component as the deviation from the trend
cycle_approx <- arima_series - trend_approx[1:length(arima_series)]

# Set up the plot layout
par(mfrow=c(3, 1))

# Plot 1: Original Series
plot(arima_series, main="ARIMA(2,1,1) Series", ylab="Value", type="l", col="black")
lines(trend_approx[1:length(arima_series)], col="blue", lwd=2) # For comparison

# Plot 2: Trend Component
plot(trend_approx, main="Estimated B-N Trend Component", ylab="Trend", col="blue", type="l")

# Plot 3: Cycle Component
plot(cycle_approx, main="Estimated B-NCycle Component", ylab="Cycle", col="red", type="l")

# Reset the plotting layout
par(mfrow=c(1, 1))

