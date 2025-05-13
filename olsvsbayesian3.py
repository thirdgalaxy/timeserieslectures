#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Apr 28 13:41:54 2025

@author: Ozan Hatipoglu
"""
import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import invgamma, norm

# Simulate Data
np.random.seed(123)
n = 100
X = np.random.randn(n, 1)
X = np.hstack((np.ones((n,1)), X))  # Add intercept
beta_true = np.array([1.0, 2.0])
sigma_true = 1.0
Y = X @ beta_true + sigma_true * np.random.randn(n)

#----------------------------------------
# OLS Estimation
XtX = X.T @ X
XtY = X.T @ Y
beta_ols = np.linalg.inv(XtX) @ XtY
sigma2_ols = np.sum((Y - X @ beta_ols)**2) / (n - X.shape[1])
var_beta_ols = sigma2_ols * np.linalg.inv(XtX)
se_beta_ols = np.sqrt(np.diag(var_beta_ols))

#----------------------------------------
# Bayesian Estimation (Non-informative Prior)
#----------------------------------------

# Priors
beta0_flat = np.zeros(2)
V0_flat = np.eye(2) * 1e6   # Diffuse prior
alpha0 = 2.0
beta0_sigma = 1.0

# Gibbs settings
n_iter = 5000
beta_samples_flat = np.zeros((n_iter, 2))

# Initialize
beta = np.zeros(2)
sigma2 = 1.0

for it in range(n_iter):
    V1 = np.linalg.inv(X.T @ X / sigma2 + np.linalg.inv(V0_flat))
    beta1 = V1 @ (X.T @ Y / sigma2 + np.linalg.inv(V0_flat) @ beta0_flat)
    beta = np.random.multivariate_normal(beta1, V1)

    residuals = Y - X @ beta
    alpha_post = alpha0 + n/2
    beta_post = beta0_sigma + 0.5 * np.sum(residuals**2)
    sigma2 = invgamma.rvs(a=alpha_post, scale=beta_post)

    beta_samples_flat[it, :] = beta

#----------------------------------------
# Bayesian Estimation (Informative Prior)
#----------------------------------------

# New prior: strong on slope
beta0_inf = np.array([0.0, 5.0])  # Prior mean: slope = 5
V0_inf = np.diag([1e6, 1.0])      # Intercept diffuse, slope strong

beta_samples_inf = np.zeros((n_iter, 2))
beta = np.zeros(2)
sigma2 = 1.0

for it in range(n_iter):
    V1 = np.linalg.inv(X.T @ X / sigma2 + np.linalg.inv(V0_inf))
    beta1 = V1 @ (X.T @ Y / sigma2 + np.linalg.inv(V0_inf) @ beta0_inf)
    beta = np.random.multivariate_normal(beta1, V1)

    residuals = Y - X @ beta
    alpha_post = alpha0 + n/2
    beta_post = beta0_sigma + 0.5 * np.sum(residuals**2)
    sigma2 = invgamma.rvs(a=alpha_post, scale=beta_post)

    beta_samples_inf[it, :] = beta

#----------------------------------------
# Comparison Plots
#----------------------------------------
fig, axs = plt.subplots(1, 2, figsize=(16,6))

# Intercept
axs[0].hist(beta_samples_flat[:,0], bins=30, density=True, alpha=0.5, label='Bayes (flat prior)')
axs[0].hist(beta_samples_inf[:,0], bins=30, density=True, alpha=0.5, label='Bayes (informative prior)')
axs[0].axvline(beta_ols[0], color='red', linestyle='--', label='OLS Estimate')
axs[0].set_title('Intercept')
axs[0].legend()

# Slope
axs[1].hist(beta_samples_flat[:,1], bins=30, density=True, alpha=0.5, label='Bayes (flat prior)')
axs[1].hist(beta_samples_inf[:,1], bins=30, density=True, alpha=0.5, label='Bayes (informative prior)')
axs[1].axvline(beta_ols[1], color='red', linestyle='--', label='OLS Estimate')
axs[1].axvline(5.0, color='green', linestyle='-.', label='Prior Mean (5.0)')
axs[1].set_title('Slope')
axs[1].legend()

plt.tight_layout()
plt.show()