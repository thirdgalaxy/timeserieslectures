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
XtY = X.T @ Y

# Posterior computation
V1 = np.linalg.inv(XtX / sigma2 + np.linalg.inv(V0))
beta1 = V1 @ (XtY / sigma2 + np.linalg.inv(V0) @ beta0)

# Draw samples from the posterior
n_samples = 5000
beta_samples = np.random.multivariate_normal(beta1, V1, n_samples)

# Plot
plt.figure(figsize=(10,4))
plt.subplot(1,2,1)
plt.hist(beta_samples[:,0], bins=30, density=True)
plt.title('Posterior of Intercept')
plt.subplot(1,2,2)
plt.hist(beta_samples[:,1], bins=30, density=True)
plt.title('Posterior of Slope')
plt.show()