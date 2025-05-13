#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Apr 28 14:08:45 2025

@author: Ozan Hatipoglu
"""
import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import beta

# Create figure
theta = np.linspace(0, 1, 1000)

# True and pseudo-true values
theta_true = 0.7
theta_pseudo = 0.5

# Posterior distributions
posterior_good = beta.pdf(theta, 100, 30)        # concentrated near true value
posterior_bad = beta.pdf(theta, 20, 80)           # excludes true value
posterior_misspec = beta.pdf(theta, 50, 50)       # pseudo-true at 0.5

# Plot
plt.figure(figsize=(12,6))

# Normal success
plt.plot(theta, posterior_good, label='Posterior (Prior covers truth)', color='blue')
plt.axvline(theta_true, color='red', linestyle='--', label=r'True $\theta^\ast=0.7$')

# Failure: prior excludes truth
plt.plot(theta, posterior_bad, label='Posterior (Prior excludes truth)', color='orange')

# Misspecification
plt.plot(theta, posterior_misspec, label='Posterior (Model misspecified)', color='green')
plt.axvline(theta_pseudo, color='green', linestyle='--', label=r'Pseudo-true $\theta^\dagger=0.5$')

plt.title('Posterior Behavior: Success vs Failure')
plt.xlabel(r'Parameter $\theta$')
plt.ylabel('Density')
plt.legend()
plt.grid(True)
plt.show()