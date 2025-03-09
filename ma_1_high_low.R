# Load necessary library
library(ggplot2)

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

# Parameters
n = 30  # Number of observations
theta_high = 2.2  # High persistence
theta_low = 0.2  # Low persistence

# Generate MA(1) processes
Y_high = generate_ma1(n, theta_high)
Y_low = generate_ma1(n, theta_low)

# Create a data frame for plotting
data <- data.frame(Time = 1:n, High_Persistence = Y_high, Low_Persistence = Y_low)

# Melting data for ggplot2
data_melted <- reshape2::melt(data, id.vars = 'Time')

# Plot series with lines and points
ggplot(data_melted, aes(x = Time, y = value, color = variable)) +
  geom_line() + 
  geom_point() +
  labs(title = "MA(1) Processes with High and Low Persistence",
       x = "Time", y = "Value", color = "Persistence") +
  theme_minimal()
