#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue May  6 07:30:09 2025

@author: Ozan Hatipoglu
"""
import numpy as np
import matplotlib.pyplot as plt

# Simulate data
np.random.seed(42)
n = 100
X = np.random.randn(n, 1)
X = np.hstack((np.ones((n,1)), X))  # Add intercept
beta_true = np.array([2.0, 3.0])
sigma_true = 1.0
Y = X @ beta_true + sigma_true * np.random.randn(n)

# Prior
beta0 = np.array([0.0, 0.0])
V0 = np.eye(2) * 10.0

# Likelihood components
sigma2 = sigma_true ** 2

XtX = X.T @ X 
# This calculates the matrix product  X^{\top} X .
#X.T is the transpose of the design matrix  X \in \mathbb{R}^{n \times k} , 
# so X.T has shape  k \times n 
#@ is Python’s matrix multiplication operator
# This results in a  k \times k  matrix of sum-of-squares and cross-products.
#  X^{\top} X  appears in both the MLE (ordinary least squares) estimator and 
# in the posterior covariance  V_1 .

XtY = X.T @ Y
#This calculates the vector  X^{\top} Y .
#Y is an  n \times 1  column vector of observations.
#X.T @ Y is a  k \times 1  vector of inner products between the regressors and 
#the outcome.
#This also appears in the MLE formula  
#\hat{\beta}_{OLS} = (X^{\top} X)^{-1} X^{\top} Y , and in the posterior mean 
#formula in Bayesian regression:

#\beta_1 = V_1 \left( \frac{X^\top Y}{\sigma^2} + V_0^{-1} \beta_0 \right)

# Posterior computation
V1 = np.linalg.inv(XtX / sigma2 + np.linalg.inv(V0))

# V_1 = \left( \frac{X^\top X}{\sigma^2} + V_0^{-1} \right)^{-1}
#This is the posterior covariance matrix of the regression coefficients  
#\beta \mid Y \sim \mathcal{N}(\beta_1, V_1) . Here’s what each term means:
#XtX / sigma2 →  \frac{X^\top X}{\sigma^2} : this comes from the likelihood and 
#represents the information from the data.
#np.linalg.inv(V0) →  V_0^{-1} : 
#this is the prior precision matrix (inverse of prior covariance).  
#V_0  is the prior covariance of  \beta .
#The sum  \frac{X^\top X}{\sigma^2} + V_0^{-1}  represents the precision 
#(inverse of covariance) 
#of the posterior distribution.
#np.linalg.inv(...) takes the inverse of that precision matrix to obtain the 
#posterior covariance  V_1 .

beta1 = V1 @ (XtY / sigma2 + np.linalg.inv(V0) @ beta0)

#\beta_1 = V_1 \left( \frac{X^\top Y}{\sigma^2} + V_0^{-1} \beta_0 \right)


#This is the posterior mean of  \beta .
#XtY / sigma2 →  \frac{X^\top Y}{\sigma^2} : This is from the likelihood and 
#corresponds to the contribution of the data to the posterior.
#np.linalg.inv(V0) @ beta0 →  V_0^{-1} \beta_0 : This is from the prior, where 
# \beta_0  is the prior mean and  V_0  is the prior covariance.
#The term inside the parentheses is the weighted sum of the data and the prior, 
#weighted by their precision (inverse variance).
#Multiplying by V1 gives the posterior mean, since we’re now converting the 
#posterior precision back to covariance.

#Intuition:

#The posterior mean  \beta_1  is a weighted average of the prior mean and the
# OLS estimator, with the weights reflecting their relative certainty 
# (precision). If your prior is strong (low variance), it pulls  \beta_1  
# toward  \beta_0 . If the data are informative (large sample, low noise), 
# it pulls toward the MLE.

# Draw samples from the posterior
n_samples = 5000
beta_samples = np.random.multivariate_normal(beta1, V1, n_samples)

#This code draws 5000 random samples from the posterior distribution of the 
#regression coefficients  \beta , which (under the assumptions of Bayesian 
#linear regression with Gaussian prior and Gaussian likelihood) follows a 
#multivariate normal distribution:

# Plot
plt.figure(figsize=(10,4))
plt.subplot(1,2,1)
plt.hist(beta_samples[:,0], bins=30, density=True)
plt.title('Posterior of Intercept')
plt.subplot(1,2,2)
plt.hist(beta_samples[:,1], bins=30, density=True)
plt.title('Posterior of Slope')
plt.show()