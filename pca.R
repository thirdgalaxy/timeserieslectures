set.seed(123) # For reproducibility
n_countries <- 20
n_observations <- 120
n_variables <- 4 # GDP, i, OIL, and pi

# Simulate random data
data <- array(runif(n_observations * n_countries * n_variables), dim = c(n_observations, n_countries, n_variables))

# Naming the variables for clarity
dimnames(data)[[3]] <- c("GDP", "i", "OIL", "pi")

# Example of accessing the GDP data for the first country
gdp_country1 <- data[, 1, "GDP"]


# Assuming 'data' is your 3D array from the previous example
# Flatten the 3D array to a 2D matrix suitable for PCA

data_matrix <- array(data, dim = c(n_observations, n_countries * n_variables))

# Running PCA on the reshaped data matrix
pca_result <- prcomp(data_matrix, center = TRUE, scale. = TRUE)

# Summary of PCA results
summary(pca_result)

# Visualize PCA results
plot(pca_result)

#Loadings

pca_result$rotation[,1]


# Assuming pca_result contains your PCA output
# And data_matrix is your original data matrix

# Step 1: Use the PCA scores for the first few principal components
pc_scores <- pca_result$x[, 1:N] # N is the number of principal components you've chosen based on variance explained

# Step 2: Fit a regression model using PC scores to forecast interest rates
# For simplicity, assuming interest rates are in the second column across all countries
interest_rates <- data_matrix[, seq(2, ncol(data_matrix), by = 4)] # Extracting interest rates for each country

# Flatten interest rates to match the observations dimension
interest_rates_vector <- as.vector(t(interest_rates))

# Fit model (adjust according to your specific forecasting model choice, here a simple linear model as an example)
model <- lm(interest_rates_vector ~ pc_scores)

# Step 3: Forecast interest rates using the model
# This would typically involve using new PCA-transformed data (following the same transformation as your training set)
# Here, simply demonstrating using the same PCA scores for illustration
forecast <- predict(model, newdata = data.frame(pc_scores))

# Reshape forecast back to the original data structure, if necessary
# And proceed with further analysis or model evaluation


