#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Apr 28 13:56:22 2025

@author: Ozan Hatipoglu
"""
import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import beta

# Prior parameters
alpha_prior = 2
beta_prior = 2

# Data
n = 10
y = 7

# Posterior parameters
alpha_post = alpha_prior + y
beta_post = beta_prior + (n - y)

# Plot
theta = np.linspace(0,1,1000)
prior_pdf = beta.pdf(theta, alpha_prior, beta_prior)
posterior_pdf = beta.pdf(theta, alpha_post, beta_post)

plt.figure(figsize=(10,5))
plt.plot(theta, prior_pdf, label='Prior Beta(2,2)', linestyle='--')
plt.plot(theta, posterior_pdf, label=f'Posterior Beta({alpha_post},{beta_post})', linewidth=2)
plt.axvline(7/10, color='red', linestyle=':', label='Sample Proportion 0.7')
plt.title('Bayesian Updating: Coin Toss Example')
plt.xlabel(r'$\theta$')
plt.ylabel('Density')
plt.legend()
plt.show()