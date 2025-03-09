# Ozan Hatipoglu - Advanced Time Series Lecture Notes
# In this exercise  
# 1) we first simulate  3 variables , call them X , Y and Z where Y and Z are more correlated  with each 
# other than with X. See the covariance matrix.  
# 2) fit a VAR model to the simulated data. This step is preliminary to identifying and estimating the SVAR model.
# 3) Apply Recursive identification (Cholesky decomposition) consistent with the covariance structure, specifically 
# X→Y→Z ordering, where shocks to X and Y do not affect Y and Z contemporaneously, respectively, but shocks 
# to Z can affect both X and Y   within the same period.
# 4): Analysis and Impulse Response Functions
# Analyze the SVAR model's impulse responses to study how shocks to each variable affect the system.
# !! See lecture notes of  SVAR with either ‘A-model’, ‘B-model’ or ‘AB-model’ is implemented.  
# Note there are several packages that can handle VAR and SVAR. 

if(!require(vars)) install.packages("vars")
if(!require(MASS)) install.packages("MASS")
if(!require(MTS)) install.packages("MTS")

library(vars)
library(MASS)
set.seed(123) # For reproducibility

# Step 1 
# Number of observations
n <- 1000

# Mean vector
mu <- c(X = 0, Y = 0, Z = 0)

# Covariance matrix (specify higher correlation between Y and Z)
Sigma <- matrix(c(1, 0.1, 0.1,  # Covariance between X and others
                  0.1, 1, 0.8,  # Covariance between Y and Z
                  0.1, 0.8, 1), # Symmetric
                byrow = TRUE, nrow = 3)

# Simulate the data
data <- mvrnorm(n = n, mu = mu, Sigma = Sigma)
colnames(data) <- c("X", "Y", "Z")
data <- ts(data)

# Step 2 
# Fit a VAR model, select order by AIC
var_model <- VAR(data_ts, p = 3, type = "const")

# Check summary
summary(var_model)
# Check var-covar
var_model$Sigma

# Step 3 

# Estimate SVAR with Cholesky decomposition based on the specified ordering as specified above
#X→Y→Z

amat <- diag(3)
diag(amat) <- NA
amat[2, 1] <- NA
amat[3, 1] <- NA


svar_model <- SVAR(var_model, method = "chol", ordering = c("X", "Y", "Z"))

SVAR(x = var_model , estmethod = "scoring", Amat = amat, Bmat = NULL,max.iter = 100, maxls = 1000, conv.crit = 1.0e-8) 
     
# Summary of the SVAR model
summary(svar_model)

# Estimate SVAR with Cholesky decomposition based on the specified ordering
svar_model <- SVAR(var_model, method = "chol", ordering = c("X", "Y", "Z"))

# Step 4 
# Summary of the SVAR model
summary(svar_model)

# Plot impulse response functions
irf(svar_model, n.ahead = 20, boot = TRUE, ci = 0.95)


library(MTS)

data_ts <- ts(data, frequency=1) # Adjust frequency as appropriate
var_result <- VAR(data_ts, p = 2, type = "const")


# Fit a VAR model (if you haven't already with 'vars')
var_result <- VAR(data_ts, p=2, output=FALSE)

# Apply SVAR analysis with Cholesky decomposition
svar_result <- SVAR(var_result, p=2, type="chol")

# Summary of the SVAR model
summary(svar_result)

# Impulse response analysis
irf_result <- irf(svar_result$A, svar_result$B, n.ahead=10)
plot(irf_result)

