#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Apr 28 10:48:12 2025

@author: Ozan Hatipoglu
"""
import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import invgamma

# Simulate data
np.random.seed(42)
n = 100
X = np.random.randn(n, 1)
X = np.hstack((np.ones((n,1)), X))  # Add intercept
beta_true = np.array([2.0, 3.0])
sigma2_true = np.random.gamma(2.0, 1.0/2.0, size=n)  # Heteroskedastic variances
Y = X @ beta_true + np.random.randn(n) * np.sqrt(sigma2_true)

# Prior hyperparameters
beta0 = np.zeros(2)
V0 = np.eye(2) * 10
alpha0 = 2.0
beta0_ = 2.0

# Gibbs settings
n_iter = 5000
beta_samples = np.zeros((n_iter, 2))
sigma2_samples = np.zeros((n_iter, n))

# Initialize
beta = np.zeros(2)
sigma2 = np.ones(n)

for it in range(n_iter):
    # Sample beta conditional on sigma2
    W_inv = np.diag(1.0 / sigma2)
    V1 = np.linalg.inv(X.T @ W_inv @ X + np.linalg.inv(V0))
    beta1 = V1 @ (X.T @ W_inv @ Y + np.linalg.inv(V0) @ beta0)
    beta = np.random.multivariate_normal(beta1, V1)

    # Sample sigma2 conditional on beta
    residuals = Y - X @ beta
    alpha_post = alpha0 + 0.5
    beta_post = beta0_ + 0.5 * residuals**2
    sigma2 = invgamma.rvs(a=alpha_post, scale=beta_post)

    # Store
    beta_samples[it, :] = beta
    sigma2_samples[it, :] = sigma2

# Posterior plots
plt.figure(figsize=(12,5))
plt.subplot(1,2,1)
plt.hist(beta_samples[:,0], bins=30, density=True)
plt.title('Posterior of Intercept')
plt.subplot(1,2,2)
plt.hist(beta_samples[:,1], bins=30, density=True)
plt.title('Posterior of Slope')
plt.show()