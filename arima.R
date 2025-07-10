set.seed(553)
## list description for AR(1) model with small coef
AR_sm <- list(order = c(1, 0, 0), ar = 0.1)
## list description for AR(1) model with  coef
AR_med <- list(order = c(1, 0, 0), ar = 0.5)
AR_lg <- list(order = c(1, 0, 0), ar = 0.9)
AR1_div <- list(order = c(1, 0, 0), ar = 0.1)



## simulate AR(1)
AR_sm <- arima.sim(n = 50, model = AR_sm, sd = 0.1)
AR_med <- arima.sim(n = 50, model = AR_med, sd = 0.1)
AR_lg <- arima.sim(n = 50, model = AR_lg, sd = 0.1)
AR1_div <- arima.sim(n = 50, model = AR1_div, sd = 3)

AR1_div <- list(order = c(1, 0, 0), ar = 1.1)

## setup plot region
par(mfrow = c(1, 3))
## get y-limits for common plots
ylm <- c(min(AR_sm, AR_lg, AR1_div), max(AR_sm, AR_lg, AR1_div))
## plot the ts
plot.ts(AR_sm, ylim = ylm, ylab = expression(italic(x)[italic(t)]), 
        main = "alpha = 0.1, sigma = 0.1")
plot.ts(AR_lg, ylim = ylm, ylab = expression(italic(x)[italic(t)]), 
        main = "alpha = 0.9, sigma = 0.1")
plot.ts(AR1_div, ylim = ylm, ylab = expression(italic(x)[italic(t)]), 
        main = "alpha = 0.9, sigma = 1.2")




