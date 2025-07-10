# AUTHOR: OZAN HATIPOGLU - ADVANCED TIME SERIES LECTURE NOTES
# This is another example of the BEveridge -Nelson Decomposition. Note that for each process you 
# you have to  derive algebraically the Permanent and Trend Component first 
# using lag operators as demonstrated in class
# 
# Load necessary library
library(forecast)

# Set seed for reproducibility
set.seed(123)

# Simulate a stationary ARMA(2,1) series
n <- 1000  # Define the length of the time series
arma_series <- arima.sim(n = n, model = list(ar = c(1.2, -0.3), ma = 0.8))

# Integrate the ARMA series to make it non-stationary, akin to simulating an ARIMA(2,1,1) series
arima_series <- cumsum(arma_series)  # This is now a non-stationary series

# Fit an ARIMA(2,1,1) model to the non-stationary series
fit <- Arima(arima_series, order = c(2, 1, 1), include.constant = TRUE)

# Forecast the series using the fitted model to extract the trend component
h <- 100  # Horizon for forecasting
forecasts <- forecast(fit, h = h)

# The Beveridge-Nelson decomposition
# Here, the stochastic trend is approximated as the original series itself, 
# given the nature of the integration step to simulate non-stationarity
stochastic_trend <- arima_series

# Cycle component is approximated by the residuals of the ARIMA model, 
# representing the transitory deviations from the trend
cycle <- residuals(fit)

# Plot the series, stochastic trend, and cycle
plot.ts(arima_series, main="Non-stationary Series and Beveridge-Nelson Decomposition", col="blue", ylab="Value")
lines(stochastic_trend, col="red")
lines(cycle + mean(stochastic_trend), col="green")
legend("topleft", legend=c("Original Series", "Stochastic Trend", "Cycle"), col=c("blue", "red", "green"), lty=1)

