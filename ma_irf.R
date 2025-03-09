# Load necessary libraries
library(ggplot2)
library(reshape2)

# Function to generate MA(1) process
generate_ma1 <- function(n, theta) {
  epsilon <- rnorm(n)  # White noise
  Y <- rep(0, n)  # Initialize Y
  Y[1] <- epsilon[1]  # First value is just white noise
  
  for(t in 2:n) {
    Y[t] <- epsilon[t] + theta * epsilon[t-1]  # MA(1) formula
  }
  
  return(Y)
}

# Function to calculate impulse response
impulse_response <- function(theta, n) {
  # For MA(1), the impulse response is just [1, theta] for the first two lags
  response <- c(1, theta)
  # Fill the rest with zeros as MA(1) impact vanishes after lag 1
  response <- c(response, rep(0, n-2))
  return(response)
}

# Parameters
n = 10  # Number of observations
theta_high = 1.2  # High persistence
theta_low = 0.2  # Low persistence

# Generate MA(1) processes
Y_high = generate_ma1(n, theta_high)
Y_low = generate_ma1(n, theta_low)

# Calculate impulse responses
IR_high = impulse_response(theta_high, n)
IR_low = impulse_response(theta_low, n)

# Create data frames for plotting
data_series <- data.frame(Time = 1:n, High_Persistence = Y_high, Low_Persistence = Y_low)
data_ir <- data.frame(Lag = 0:(n-1), High_Persistence_IR = IR_high, Low_Persistence_IR = IR_low)

# Melting data for ggplot2
data_series_melted <- melt(data_series, id.vars = 'Time')
data_ir_melted <- melt(data_ir, id.vars = 'Lag')

# Plot series
ggplot(data_series_melted, aes(x = Time, y = value, color = variable)) +
  geom_line() +
  labs(title = "MA(1) Processes with High and Low Persistence",
       x = "Time", y = "Value", color = "Persistence") +
  theme_minimal()

# Plot impulse responses
ggplot(data_ir_melted, aes(x = Lag, y = value, color = variable)) +
  geom_line() +
  labs(title = "Impulse Response Functions",
       x = "Lag", y = "Response", color = "Persistence") +
  theme_minimal()
