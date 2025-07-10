# AUTHOR: OZAN HATIPOGLU - ADVANCED TIME SERIES LECTURE NOTES
# THIS CODE NEEDS UPDATING !!!
set.seed(123) # For reproducibility
n <- 100 # Number of observations

# Generate synthetic data
GDP <- cumsum(rnorm(n, 0, 1)) # Cumulative sum to simulate growth
InterestRates <- runif(n, 0, 10)
Inflation <- runif(n, 0, 5)
Technology <- cumsum(rnorm(n, 0, 1))
Tariffs <- runif(n, 0, 20)

# Combine into a data frame
data <- data.frame(GDP, InterestRates, Inflation, Technology, Tariffs)
library(vars)

# Specify a VAR model of order 2
var_model <- VAR(data, p = 2, type = "both")

# SVAR model with short-run restrictions
svar_model <- SVAR(var_model, method = "A", 
                   A = matrix(c(1, 0, 0, 0, 0,    # GDP equation
                                NA, 1, 0, 0, 0,  # InterestRates equation
                                NA, NA, 1, 0, 0, # Inflation equation
                                NA, NA, NA, 1, 0,# Technology equation
                                NA, NA, NA, NA, 1# Tariffs equation
                   ), 
                   byrow = TRUE, nrow = 5))

irf <- irf(svar_model, impulse = "Technology", response = "GDP", n.ahead = 10)

# Plot the impulse response
plot(irf)
# FEVD analysis
fevd_model <- fevd(svar_model, n.ahead = 10)

# Plot FEVD for GDP
plot(fevd_model, "GDP")
