#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Apr 28 13:35:17 2025

@author: Ozan Hatipoglu
"""
import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import invgamma, norm

# Simulate same Data
np.random.seed(123)
n = 100
X = np.random.randn(n, 1)
X = np.hstack((np.ones((n,1)), X))  # Add intercept
beta_true = np.array([1.0, 2.0])
sigma_true = 1.0
Y = X @ beta_true + sigma_true * np.random.randn(n)

#----------------------------------------
# OLS Estimation (Same as before)
XtX = X.T @ X
XtY = X.T @ Y
beta_ols = np.linalg.inv(XtX) @ XtY
sigma2_ols = np.sum((Y - X @ beta_ols)**2) / (n - X.shape[1])
var_beta_ols = sigma2_ols * np.linalg.inv(XtX)
se_beta_ols = np.sqrt(np.diag(var_beta_ols))

#----------------------------------------
# Bayesian Estimation with Informative Prior
#----------------------------------------

# New Priors
beta0 = np.array([0.0, 5.0])       # Prior means: intercept ~ 0, slope ~ 5
V0 = np.diag([1e6, 1.0])           # Prior variances: intercept very diffuse, slope tight
alpha0 = 2.0
beta0_sigma = 1.0

# Gibbs settings
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

# Bayesian estimates
beta_bayes_mean = np.mean(beta_samples, axis=0)
beta_bayes_std = np.std(beta_samples, axis=0)
ci_bayes_lower = np.percentile(beta_samples, 2.5, axis=0)
ci_bayes_upper = np.percentile(beta_samples, 97.5, axis=0)

print("\nBayesian Estimates with Informative Prior")
print("-----------------------------------------")
for i in range(len(beta_bayes_mean)):
    print(f"Beta {i}: {beta_bayes_mean[i]:.4f} (Posterior SD: {beta_bayes_std[i]:.4f})")
    print(f"  95% Credible Interval: ({ci_bayes_lower[i]:.4f}, {ci_bayes_upper[i]:.4f})")

#----------------------------------------
# Plots
#----------------------------------------
fig, axs = plt.subplots(1, 2, figsize=(14,6))

# Intercept
axs[0].hist(beta_samples[:,0], bins=30, density=True, alpha=0.6, label='Bayes Posterior')
axs[0].axvline(beta_ols[0], color='red', linestyle='--', label='OLS Estimate')
axs[0].set_title('Intercept')
axs[0].legend()

# Slope
axs[1].hist(beta_samples[:,1], bins=30, density=True, alpha=0.6, label='Bayes Posterior')
axs[1].axvline(beta_ols[1], color='red', linestyle='--', label='OLS Estimate')
axs[1].axvline(5.0, color='green', linestyle='-.', label='Prior Mean = 5')
axs[1].set_title('Slope')
axs[1].legend()

plt.tight_layout()
plt.show()