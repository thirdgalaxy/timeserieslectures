# Load necessary library
library(ggplot2)
library(dplyr)

# Function to simulate a Markov process
simulate_markov <- function(trans_matrix, initial_state, n) {
  states <- colnames(trans_matrix)
  state_sequence <- character(n)
  state_sequence[1] <- initial_state
  for (i in 2:n) {
    current_state <- which(states == state_sequence[i - 1])
    state_sequence[i] <- sample(states, size = 1, prob = trans_matrix[current_state, ])
  }
  return(state_sequence)
}

# Define the transition matrix for weather simulation
transition_matrix <- matrix(c(0.8, 0.2, 0.4, 0.6), byrow = TRUE, nrow = 2)
colnames(transition_matrix) <- c("Sunny", "Rainy")
rownames(transition_matrix) <- c("Sunny", "Rainy")

# Simulate the weather for 30 days
set.seed(123)
simulated_weather <- simulate_markov(transition_matrix, initial_state = "Sunny", n = 30)

# Create a data frame for plotting
weather_df <- data.frame(Day = 1:30, Weather = simulated_weather)

# Count the number of Sunny and Rainy days
weather_count <- weather_df %>% count(Weather)

# Create annotation text
annotation_text <- paste(weather_count$Weather, ": ", weather_count$n, sep = "")

# Plotting using points
p <- ggplot(weather_df, aes(x = Day, y = Weather)) +
  geom_point(size = 3) +
  scale_y_discrete(limits = c("Sunny", "Rainy")) +
  labs(title = "30-Day Weather Simulation (Markov Process)", x = "Day", y = "Weather") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  annotate("text", x = max(weather_df$Day)/2, y = 1.5, label = annotation_text[1], vjust = -1) +
  annotate("text", x = max(weather_df$Day)/2, y = 1.5, label = annotation_text[2], vjust = 1)

print(p)

