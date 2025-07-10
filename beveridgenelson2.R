# AUTHOR: OZAN HATIPOGLU - ADVANCED TIME SERIES LECTURE NOTES
# This is another example of the Beveridge -Nelson Decomposition. Note that for each process you 
# you have to  derive algebraically the Permanent and Trend Component first 
# using lag operators as demonstrated in class
# 
# Ensure the necessary libraries are installed and loaded
if (!require("forecast")) install.packages("forecast")
if (!require("ggplot2")) install.packages("ggplot2")
if (!require("gridExtra")) install.packages("gridExtra")

library(forecast)
library(ggplot2)
library(gridExtra)

# Set seed for reproducibility
set.seed(123)

# Define the number of observations
n <- 1000

# Simulate an ARIMA(2,1,1) series
arima_series <- arima.sim(model=list(ar=c(0.5, -0.3), ma=0.4), n=n)

# Fit an ARIMA(2,1,1) model to the simulated series
fit <- Arima(arima_series, order=c(2,1,1))

# Generate forecasts from the fitted model for 100 steps ahead
forecasts <- forecast(fit, h=100)

# Original time series plot
p_original <- ggplot(data.frame(Time=1:n, Value=arima_series), aes(x=Time, y=Value)) +
  geom_line() +
  theme_minimal() +
  labs(title="Original ARIMA(2,1,1) Series", x="Time", y="Value")

# Plotting the forecasts
p_forecast <- ggplot(data.frame(Time=(n+1):(n+100), Value=forecasts$mean), aes(x=Time, y=Value)) +
  geom_line(color="blue") +
  theme_minimal() +
  labs(title="Forecasted Trend", x="Time", y="Value")

# Residuals plot
p_residuals <- ggplot(data.frame(Time=1:n, Value=residuals(fit)), aes(x=Time, y=Value)) +
  geom_line(color="red") +
  theme_minimal() +
  labs(title="Residuals (Cycle Component)", x="Time", y="Value")

# Arrange all plots in a single layout
grid.arrange(p_original, p_forecast, p_residuals, nrow=3)


