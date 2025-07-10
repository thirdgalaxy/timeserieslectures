#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue May 13 09:13:24 2025

Implementation of the Extended Kalman Filter for Nonlinear Asset Pricing Model 

@author: Ozan Hatipoglu

"""
import numpy as np
import matplotlib.pyplot as plt

# Parameters
alpha = 0.1
beta = 0.05
Q = 0.05  # Increased process noise variance
R = 0.5   # Decreased measurement noise variance
n = 100   # Number of time steps

# Initialize states and observations
X_true = np.zeros(n)
Y_true = np.zeros(n)
X_est = np.zeros(n)
P = np.zeros(n)

# Initial values
X_true[0] = 0.5
Y_true[0] = np.exp(X_true[0]) + np.random.normal(0, np.sqrt(R))
X_est[0] = 0.5  # Initial guess
P[0] = 1.0      # Initial variance

# EKF Loop
for t in range(1, n):
    # Prediction Step
    X_pred = X_est[t-1] + alpha * (1 - np.exp(-beta * X_est[t-1]))
    F = 1 + alpha * beta * np.exp(-beta * X_est[t-1])  # Jacobian
    P_pred = F * P[t-1] * F + Q
    
    # Update Step
    Y_pred = np.exp(X_pred)
    K = P_pred / (P_pred + R)  # Kalman gain
    X_est[t] = X_pred + K * (Y_true[t] - Y_pred)
    P[t] = (1 - K) * P_pred
    
    # Simulate the true process for comparison
    X_true[t] = X_true[t-1] + alpha * (1 - np.exp(-beta * X_true[t-1])) + np.random.normal(0, np.sqrt(Q))
    Y_true[t] = np.exp(X_true[t]) + np.random.normal(0, np.sqrt(R))

# Plot Results
plt.figure(figsize=(10, 6))
plt.plot(Y_true, label='True Observations')
plt.plot(X_est, label='EKF Estimate', linestyle='--')
plt.legend()
plt.title('Extended Kalman Filter - Nonlinear Model')
plt.xlabel('Time Step')
plt.ylabel('Value')
plt.show()