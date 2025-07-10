# Author: Ozan Hatipoglu - Advanced Time Series Lecture Notes
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
# Install and load only what's needed

# Install required packages
if (!require("vars")) install.packages("vars")
if (!require("svars")) install.packages("svars")
if (!require("MASS")) install.packages("MASS")


library(MASS)
library(vars)   # make sure vars is loaded after MTS
library(svars)

# Simulate correlated data
set.seed(123)
n <- 1000
mu <- c(0, 0, 0)
Sigma <- matrix(c(1, 0.1, 0.1,
                  0.1, 1, 0.8,
                  0.1, 0.8, 1), nrow = 3, byrow = TRUE)
data <- mvrnorm(n, mu = mu, Sigma = Sigma)
colnames(data) <- c("X", "Y", "Z")
data_ts <- ts(data)

# Estimate VAR (note the namespace prefix!)
var_model <- vars::VAR(data_ts, p = 2, type = "const")

# Identify SVAR using recursive (Cholesky) ordering
svar_chol <- svars::id.chol(var_model)

# IRF using vars package
irf_result <- vars::irf(svar_chol, n.ahead = 20, boot = TRUE, ci = 0.95)
plot(irf_result)