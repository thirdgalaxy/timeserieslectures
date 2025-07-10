# Load necessary library
library(ggplot2)

# Function to simulate AR(1) process
simulate_ar1 <- function(phi, n, start_value, sigma) {
  series <- numeric(n)
  series[1] <- start_value
  for (i in 2:n) {
    series[i] <- phi * series[i - 1] + rnorm(sigma)
  }
  return(series)
}

# Set parameters
n <- 30
sigma <- 1
# number of observations
start_value <- 0  # starting value for all series

# Simulate AR(1) processes with different coefficients
ar1_0.1 <- simulate_ar1(0.1, n, start_value, sigma)
ar1_0.8 <- simulate_ar1(-0.8, n, start_value, sigma)
ar1_1.1 <- simulate_ar1(1.1, n, start_value, sigma)


# Create a data frame for plotting
df <- data.frame(
  time = 1:n,
  AR1_0.1 = ar1_0.1,
  AR1_0.8 = ar1_0.8,
  AR1_1.1 = ar1_1.1
)

# Reshape data for ggplot
df_long <- reshape2::melt(df, id.vars = "time")

# Plotting
ggplot(df_long, aes(x = time, y = value, color = variable)) +
  geom_line() +
  labs(title = "Simulated AR(1) Processes",
       x = "Time",
       y = "Value",
       color = "AR Coefficient") +
  theme_minimal()

