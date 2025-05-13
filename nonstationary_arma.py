#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Mar 10 16:33:15 2025

@author: Ozan Hatipoglu
"""
import numpy as np
import matplotlib.pyplot as plt

# Set parameters for ARMA(1,2)
rho_1 = [0.5, 1.0]  # Stationary case (0.5) and unit root case (1.0)
theta_1 = 0.4
theta_2 = -0.2
n = 200  # Number of time steps

# Generate white noise
np.random.seed(42)
epsilon = np.random.normal(0, 1, n)

# Initialize series
Y_stationary = np.zeros(n)
Y_unit_root = np.zeros(n)
stochastic_trend = np.zeros(n)  # Tracks the random walk component

# Generate ARMA(1,2) process
for t in range(2, n):
    Y_stationary[t] = rho_1[0] * Y_stationary[t-1] + epsilon[t] + theta_1 * epsilon[t-1] + theta_2 * epsilon[t-2]
    Y_unit_root[t] = Y_unit_root[t-1] + epsilon[t]  # Stochastic trend (Random Walk)
    stochastic_trend[t] = stochastic_trend[t-1] + epsilon[t]  # Tracking the random walk separately
    Y_unit_root[t] += theta_1 * epsilon[t-1] + theta_2 * epsilon[t-2]  # Adding stationary MA component

# Plot results
plt.figure(figsize=(12, 5))
plt.suptitle("Wold Representation")

# Stationary case
plt.subplot(1, 2, 1)
plt.plot(Y_stationary, label="Stationary ARMA(1,2)")
plt.axhline(y=0, color='k', linestyle='--', linewidth=0.8)
plt.title("Stationary ARMA(1,2) Process (ρ=0.5)")
plt.xlabel("Time")
plt.ylabel("Y_t")
plt.legend()

# Non-stationary case with stochastic trend
plt.subplot(1, 2, 2)
plt.plot(Y_unit_root, label="Non-Stationary ARMA(1,2)", color='r')
plt.plot(stochastic_trend, label="Stochastic Trend", linestyle="dashed", color='blue')
plt.axhline(y=0, color='k', linestyle='--', linewidth=0.8)
plt.title("Non-Stationary ARMA(1,2) (Stochastic Trend)")
plt.xlabel("Time")
plt.ylabel("Y_t")
plt.legend()

plt.tight_layout()
plt.show()