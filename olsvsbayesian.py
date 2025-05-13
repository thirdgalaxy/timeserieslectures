#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Apr 28 13:20:58 2025

@author: Ozan Hatipoglu
"""
import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import invgamma

# Simulate Data
np.random.seed(123)
n = 100
X = np.random.randn(n, 1)
X = np.hstack((np.ones((n,1)), X))  # Add intercept
beta_true = np.array([1.0, 2.0])
sigma_true = 1.0
Y = X @ beta_true + sigma_true * np.random.randn(n)

#----------------------------------------
# (1) OLS Estimation
#----------------------------------------
XtX = X.T @ X
XtY = X.T @ Y
beta_ols = np.linalg.inv(XtX) @ XtY
sigma2_ols = np.sum((Y - X @ beta_ols)**2) / (n - X.shape[1])
var_beta_ols = sigma2_ols * np.linalg.inv(XtX)
se_beta_ols = np.sqrt(np.diag(var_beta_ols))

print("OLS Estimates")
print("-------------")
for i in range(len(beta_ols)):
    print(f"Beta {i}: {beta_ols[i]:.4f} (SE: {se_beta_ols[i]:.4f})")

#----------------------------------------
# (2) Bayesian Estimation via Gibbs Sampling
#----------------------------------------

# Priors
beta0 = np.zeros(2)
V0 = np.eye(2) * 10
alpha0 = 2.0
beta0_sigma = 1.0

# Gibbs Sampling settings
n_iter = 5000
beta_samples = np.zeros((n_iter, 2))
sigma2_samples = np.zeros(n_iter)

# Initialize
beta = np.zeros(2)
sigma2 = 1.0

for it in range(n_iter):
    # Sample beta | sigma2, Y
    V1 = np.linalg.inv(X.T @ X / sigma2 + np.linalg.inv(V0))
    beta1 = V1 @ (X.T @ Y / sigma2 + np.linalg.inv(V0) @ beta0)
    beta = np.random.multivariate_normal(beta1, V1)

    # Sample sigma2 | beta, Y
    residuals = Y - X @ beta
    alpha_post = alpha0 + n/2
    beta_post = beta0_sigma + 0.5 * np.sum(residuals**2)
    sigma2 = invgamma.rvs(a=alpha_post, scale=beta_post)

    # Store
    beta_samples[it, :] = beta
    sigma2_samples[it] = sigma2

# Bayesian point estimates
beta_bayes_mean = np.mean(beta_samples, axis=0)
beta_bayes_std = np.std(beta_samples, axis=0)

print("\nBayesian Estimates (Posterior Means)")
print("------------------------------------")
for i in range(len(beta_bayes_mean)):
    print(f"Beta {i}: {beta_bayes_mean[i]:.4f} (Posterior SD: {beta_bayes_std[i]:.4f})")

#----------------------------------------
# (3) Comparison Plots
#----------------------------------------
plt.figure(figsize=(12,5))
plt.subplot(1,2,1)
plt.hist(beta_samples[:,0], bins=30, density=True)
plt.axvline(beta_ols[0], color='red', linestyle='--', label='OLS Estimate')
plt.title('Posterior Distribution: Intercept')
plt.legend()

plt.subplot(1,2,2)
plt.hist(beta_samples[:,1], bins=30, density=True)
plt.axvline(beta_ols[1], color='red', linestyle='--', label='OLS Estimate')
plt.title('Posterior Distribution: Slope')
plt.legend()
plt.show()