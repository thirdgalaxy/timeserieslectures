# Monte Carlo Experiment to demonstrate small sample bias of simple OLS. 
# OZAN HATIPOGLU
# packages required: broom (for tidying up the results), ggplot2 (for plotting), 
# and tictoc (for keeping time). 
# this program uses a minimum number of packages to illustrate the concept
# better algorithms available, but here we focus on econometrics,. i.e. 
# estimation methods and the matrices used. 
rm(list=ls())
require(broom)    
library(zoo)
require(ggplot2)
require(tictoc)
#start the clock
tic()
#number of iterations # this the maximum number of regressions
n=200    
# true coefficient example for AR(1), change this to see the effect of non-stationarity
beta=0.6 
z<-matrix(0,n,1)
ols_coefficients<-matrix(0,n,1)
mean_ols_c<-matrix(beta,n,1)
true_coefficient<-matrix(beta,n,1)
number_of_iterations<-matrix(1: n, n ,1)
for(j in 1: (n-1)){
  z[1,1]=1
  z[j+1,1]=beta*z[j,1]+rnorm(1, mean = 0, sd = 1)
  z_ar1<-ts(z) 
  for(i in 2: n){
    fit<-lm(z_ar1[2:i]~z_ar1[1:(i-1)])       # regressing on lagged values using simple ols
    coef1<-tidy(fit)                         # tidy up the coefficients
    ols_coefficients[i,1]=coef1[2,2] 
      }  
  mean_ols_c[j,1]=mean(ols_coefficients[1:(j-1),1], na.rm =TRUE )  }


# PART 2 Plotting

df <- data.frame(number_of_iterations,ols_coefficients,true_coefficient,mean_ols_c)

ggplot(df, aes(number_of_iterations)) +                    
  geom_line(aes(y=ols_coefficients), colour="red") +  
  geom_line(aes(y=true_coefficient), colour="green") +
  geom_line(aes(y=mean_ols_c), colour="blue") +
  labs(title="Small Sample Bias of OLS with AR(1)") +
  scale_y_continuous("AR(1) Coefficients") 

  
# Stop the clock and print elapsed time
exectime <- toc()
exectime <- exectime$toc - exectime$tic
exectime

  
