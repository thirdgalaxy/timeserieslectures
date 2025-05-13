#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Apr 28 14:02:15 2025

@author: Ozan Hatipoglu
"""
import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import beta

# True parameter
theta_true = 0.7

# Prior
alpha_prior = 2
beta_prior = 2

# Number of observations
sample_sizes = [10, 50, 200, 1000]

# Create subplots
fig, axs = plt.subplots(2, 2, figsize=(14,10))
axs = axs.ravel()

np.random.seed(123)

for i, n in enumerate(sample_sizes):
    # Simulate coin tosses
    y = np.random.binomial(n, theta_true)

    # Update posterior
    alpha_post = alpha_prior + y
    beta_post = beta_prior + (n - y)

    # Plot
    theta = np.linspace(0, 1, 1000)
    prior_pdf = beta.pdf(theta, alpha_prior, beta_prior)
    posterior_pdf = beta.pdf(theta, alpha_post, beta_post)

    axs[i].plot(theta, posterior_pdf, label=f'Posterior n={n}', color='blue')
    axs[i].plot(theta, prior_pdf, '--', label='Prior', color='black')
    axs[i].axvline(theta_true, color='red', linestyle=':', label=r'True $\theta$=0.7')
    axs[i].set_title(f'{n} Observations')
    axs[i].set_xlabel(r'$\theta$')
    axs[i].set_ylabel('Density')
    axs[i].legend()

plt.tight_layo