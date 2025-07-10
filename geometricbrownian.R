# AUTHOR: OZAN HATIPOGLU - ADVANCED TIME SERIES LECTURE NOTES
# FORWAD PROPAGATION OF A GEOMETRIC BROWNIAN MOTION USING HISTORICAL DATA ON GOLD PRICES

# Clear the R environment before running the script
rm(list = ls())  # Clears all objects in the environment
gc()             # Calls garbage collection to free up memory

library(quantmod)    # For financial data retrieval
library(ggplot2)     # For plotting
library(tidyquant)   # For time series manipulation

# Define the tickers and data start date
tickers <- c("SPY", "AAPL", "GC=F")  # S&P 500 Index, Apple Stock, Gold Futures
start_date <- "2010-01-01"

# Download the data
getSymbols(tickers, from = start_date, auto.assign = TRUE)

# Data for each: SPY, AAPL, GC=F (Gold Futures)
spy_data <- Cl(SPY)
aapl_data <- Cl(AAPL)
gold_data <- Cl(`GC=F`)  # Corrected gold ticker usage

# Function to calculate the drift and volatility (mu and sigma)
calculate_params <- function(data) {
  # Calculate daily log returns
  daily_returns <- diff(log(data))
  
  # Calculate drift (mean return) and volatility (standard deviation of returns)
  mu <- mean(daily_returns, na.rm = TRUE)  # Mean of log returns
  sigma <- sd(daily_returns, na.rm = TRUE)  # Standard deviation of log returns
  
  return(list(mu = mu, sigma = sigma))
}

# Calculate parameters for SPY, AAPL, and Gold
spy_params <- calculate_params(spy_data)
aapl_params <- calculate_params(aapl_data)
gold_params <- calculate_params(gold_data)

# Print out mu and sigma for each asset to verify
print(paste("SPY - mu:", spy_params$mu, "sigma:", spy_params$sigma))
print(paste("AAPL - mu:", aapl_params$mu, "sigma:", aapl_params$sigma))
print(paste("Gold - mu:", gold_params$mu, "sigma:", gold_params$sigma))

# Simulate GBM for a given stock or index
simulate_gbm <- function(S0, mu, sigma, T, N, dt) {
  S <- numeric(N + 1)
  S[1] <- S0
  for (i in 2:(N + 1)) {
    Z <- rnorm(1)
    S[i] <- S[i - 1] * exp((mu - 0.5 * sigma^2) * dt + sigma * sqrt(dt) * Z)
  }
  return(S)
}

# Simulation settings
T <- 1  # time period in years
N_yearly <- 252  # number of daily time steps in a year
N_daily <- 252  # daily frequency steps
N_hourly <- 252 * 6  # assuming 6 hours of trading per day, 252 days in a year

# Simulate for SPY, AAPL, Gold (monthly)
simulate_and_plot <- function(symbol_data, params, S0, symbol_name) {
  dt_yearly <- T / N_yearly
  dt_daily <- T / N_daily
  dt_hourly <- T / N_hourly
  
  simulated_yearly <- simulate_gbm(S0, params$mu, params$sigma, T, N_yearly, dt_yearly)
  simulated_daily <- simulate_gbm(S0, params$mu, params$sigma, T, N_daily, dt_daily)
  simulated_hourly <- simulate_gbm(S0, params$mu, params$sigma, T, N_hourly, dt_hourly)
  
  # Plot the results
  par(mfrow = c(3, 1))  # Three plots in a row
  plot(simulated_hourly, type = 'l', main = paste(symbol_name, "- Hourly Simulation"), xlab = 'Time (Hours)', ylab = 'Stock Price')
  plot(simulated_daily, type = 'l', main = paste(symbol_name, "- Daily Simulation"), xlab = 'Time (Days)', ylab = 'Stock Price')
  plot(simulated_yearly, type = 'l', main = paste(symbol_name, "- Yearly Simulation"), xlab = 'Time (Years)', ylab = 'Stock Price')
}

# Initial stock price is the current closing price of the asset
simulate_and_plot(spy_data, spy_params, tail(spy_data, 1), "SPY")
simulate_and_plot(aapl_data, aapl_params, tail(aapl_data, 1), "AAPL")
simulate_and_plot(gold_data, gold_params, tail(gold_data, 1), "Gold")

