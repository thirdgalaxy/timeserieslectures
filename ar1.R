# Load necessary libraries
library(ggplot2)
library(gridExtra)

# Function to simulate AR(1) process
simulate_ar1 <- function(phi, n, start_value, sd_shock) {
  series <- numeric(n)
  series[1] <- start_value
  for (i in 2:n) {
    series[i] <- phi * series[i - 1] + rnorm(1, mean = 0, sd = sd_shock)
  }
  return(series)
}

# Set parameters
n <- 50  # Number of observations
start_value <- 0  # Starting value for all series
coefficients <- c(0.1, 0.8, 1.1)
sd_shocks <- c(0.5, 1, 4)

# Prepare plots
plots <- list()
plot_num <- 1
for (coeff in coefficients) {
  for (sd_shock in sd_shocks) {
    sim_values <- simulate_ar1(coeff, n, start_value, sd_shock)
    title_text <- bquote("AR(1) with" ~ phi == .(coeff) ~ "," ~ sigma == .(sd_shock))
    p <- ggplot(data.frame(time = 1:n, value = sim_values), aes(x = time, y = value)) +
      geom_line() +
      ggtitle(title_text) +
      theme_minimal() +
      theme(plot.title = element_text(size = 8),  # Adjust title size
            axis.title = element_text(size = 7),  # Adjust axis title size
            axis.text = element_text(size = 6))   # Adjust axis text size
    plots[[plot_num]] <- p
    plot_num <- plot_num + 1
  }
}

# Combine all plots
do.call(grid.arrange, c(plots, ncol = 3))
