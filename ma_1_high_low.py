#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Feb 20 10:50:10 2024

@author: ozan
"""
import pip
pip.main(['install','seaborn'])
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

def generate_ma1(n, theta):
    """
    Function to generate MA(1) process
    """
    epsilon = np.random.normal(size=n)  # White noise
    Y = np.zeros(n)  # Initialize Y
    Y[0] = epsilon[0]  # First value is just white noise
    
    for t in range(1, n):
        Y[t] = epsilon[t] + theta * epsilon[t-1]  # MA(1) formula
    
    return Y

# Parameters
n = 30  # Number of observations
theta_high = 2.2  # High persistence
theta_low = 0.2  # Low persistence

# Generate MA(1) processes
Y_high = generate_ma1(n, theta_high)
Y_low = generate_ma1(n, theta_low)

# Create a DataFrame for plotting
df = pd.DataFrame({'Time': np.arange(1, n+1), 'High_Persistence': Y_high, 'Low_Persistence': Y_low})
df_melted = df.melt(id_vars=['Time'], var_name='Persistence', value_name='Value')

# Plot series with lines and points
sns.lineplot(data=df_melted, x='Time', y='Value', hue='Persistence', marker='o')
plt.title("MA(1) Processes with High and Low Persistence")
plt.xlabel("Time")
plt.ylabel("Value")
plt.show()