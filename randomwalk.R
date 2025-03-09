# Load necessary library
library(ggplot2)

# Function to simulate a random walk
simulate_random_walk <- function(sd, start_value = 0, n = 50, group_id, walk_id) {
  walk <- numeric(n)
  walk[1] <- start_value
  for (i in 2:n) {
    walk[i] <- walk[i - 1] + rnorm(1, mean = 0, sd = sd)
  }
  data.frame(Time = 1:n, Walk = walk, SD = sd, Group = as.factor(group_id), WalkID = as.factor(walk_id))
}

# Set seed for reproducibility
set.seed(123)

# Simulate random walks
# First panel (all with sd = 1)
rw1 <- simulate_random_walk(1, group_id = "Same SD", walk_id = "RW1 (σ=1)")
rw2 <- simulate_random_walk(1, group_id = "Same SD", walk_id = "RW2 (σ=1)")
rw3 <- simulate_random_walk(1, group_id = "Same SD", walk_id = "RW3 (σ=1)")

# Second panel (with varying sd)
rw4 <- simulate_random_walk(0.1, group_id = "Different SD", walk_id = "RW4 (σ=0.1)")
rw5 <- simulate_random_walk(1, group_id = "Different SD", walk_id = "RW5 (σ=1)")
rw6 <- simulate_random_walk(4, group_id = "Different SD", walk_id = "RW6 (σ=4)")

# Combine all data
all_walks <- rbind(rw1, rw2, rw3, rw4, rw5, rw6)

# Plotting
ggplot(all_walks, aes(x = Time, y = Walk, group = WalkID, color = WalkID)) +
  geom_line() +
  facet_grid(rows = vars(Group)) +
  theme_minimal() +
  labs(title = "Random Walk Simulations", x = "Time", y = "Walk Value", color = "Simulation ID") +
  scale_color_discrete(labels = c(expression(RW1~(sigma==1)), expression(RW2~(sigma==1)), expression(RW3~(sigma==1)),
                                  expression(RW4~(sigma==0.1)), expression(RW5~(sigma==1)), expression(RW6~(sigma==4)))) +
  theme(legend.position = "bottom")


