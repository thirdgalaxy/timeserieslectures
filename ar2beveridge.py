#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Apr 21 20:20:47 2025

@author: Ozan Hatipoglu
"""
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import yfinance as yf
from statsmodels.tsa.ar_model import AutoReg
from statsmodels.tsa.arima_process import ArmaProcess

# -------------------- Beveridge-Nelson Decomposition Function --------------------

def bn_decomposition_ar2(series, lags=2, H=100):
    series = series.dropna()
    y = series.values
    T = len(y)

    # Step 1: Fit AR(2)
    model = AutoReg(y, lags=lags, old_names=False).fit()
    phi = model.params[1:].values
    intercept = model.params[0]
    residuals = model.resid

    # Step 2: Get MA(∞) approximation via impulse response
    arma_process = ArmaProcess(ar=np.r_[1, -phi], ma=np.array([1]))
    psi_weights = arma_process.impulse_response(steps=H)

    # Step 3: Compute BN trend
    trend = np.full(T, np.nan)
    for t in range(H + lags, T):
        adjustment = np.dot(psi_weights[1:], residuals[t - 1:t - H - 1:-1])
        trend[t] = y[t] - adjustment

    # Step 4: Align and return
    valid_idx = ~np.isnan(trend)
    y_trimmed = y[valid_idx]
    trend_trimmed = trend[valid_idx]
    cycle = y_trimmed - trend_trimmed

    return pd.DataFrame({
        'y': y_trimmed,
        'trend': trend_trimmed,
        'cycle': cycle
    }, index=series.index[valid_idx])





# Simulate AR(2): y_t = 1.2 y_{t-1} - 0.4 y_{t-2} + ε_t
np.random.seed(123)
n = 300
phi1, phi2 = 1.2, -0.4
eps = np.random.normal(size=n)
y = np.zeros(n)
y[0:2] = eps[0:2]
for t in range(2, n):
    y[t] = phi1 * y[t - 1] + phi2 * y[t - 2] + eps[t]
simulated_series = pd.Series(y)

# Apply BN decomposition
bn_sim = bn_decomposition_ar2(simulated_series)

# Plot
plt.figure(figsize=(12, 6))
plt.plot(bn_sim.index, bn_sim['y'], label='Original')
plt.plot(bn_sim.index, bn_sim['trend'], label='BN Trend')
plt.plot(bn_sim.index, bn_sim['cycle'], label='Cycle')
plt.title('BN Decomposition of Simulated AR(2) Process')
plt.legend()
plt.grid(True)
plt.show()



# Download AAPL data
aapl = yf.download('AAPL', start='2010-01-01', end='2025-01-01')
log_prices = np.log(aapl['Adj Close']).dropna()

# Apply BN decomposition
bn_aapl = bn_decomposition_ar2(log_prices)

# Plot
plt.figure(figsize=(12, 6))
plt.plot(bn_aapl.index, bn_aapl['y'], label='Log Price')
plt.plot(bn_aapl.index, bn_aapl['trend'], label='BN Trend')
plt.plot(bn_aapl.index, bn_aapl['cycle'], label='Cycle')
plt.title('BN Decomposition of AAPL Log Prices')
plt.legend()
plt.grid(True)
plt.show()