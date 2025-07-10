# AUTHOR: OZAN HATIPOGLU - ADVANCED TIME SERIES LECTURE NOTES
# The Hodrick-Prescott Filter used in RBC Models using the mFilter package. 
if (!requireNamespace("mFilter", quietly = TRUE)) install.packages("mFilter")
if (!requireNamespace("ggplot2", quietly = TRUE)) install.packages("ggplot2")
library(stats)
library(mFilter)
library(ggplot2)

# Set seed for reproducibility
set.seed(123)

# Simulate ARMA(1,1) series with 100 observations.
#ARIMA (1,1,1) model can also simulated by choosing AR coefficients >1 and then taking the first difference. 
n <- 100
arima_series <- arima.sim(n = n, model = list(ar = 0.5, ma = 0.4))

# Apply HP filter
hp_result <- hpfilter(arima_series, freq = 14400)  # Adjust freq=14400 for monthly data

# Ensure the series, trend, and cycle are in a dataframe and not ts objects
df <- data.frame(
  Time = seq_len(n),
  Series = arima_series,
  Trend = hp_result$trend[1:n],  # Ensure length matches
  Cycle = hp_result$cycle[1:n]   # Ensure length matches
)

# Plotting with corrected data handling
ggplot(df, aes(x = Time)) +
  geom_line(aes(y = Series, color = "Original Series"), linetype = "dashed") +
  geom_line(aes(y = Trend, color = "Trend Component")) +
  geom_line(aes(y = Cycle, color = "Cycle Component")) +
  labs(title = "ARMA(1,1) Series with HP Filter Decomposition",
       y = "Value",
       x = "Time") +
  scale_color_manual(values = c("Original Series" = "blue", "Trend Component" = "red", "Cycle Component" = "green")) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))


