#install forecast library
install.packages("forecast")
library(forecast)

#load the lib and get Amzn stock data
require(quantmod)
getSymbols("AMZN", from="2013-01-01")
amzn = diff(log(Cl(AMZN)))

azfinal.aic<-Inf
azfinal.order<-c(0,0,0)

#loop to find the best arima mode with best parameters (p,d,q)
for (p in 1:4) for (d in 0:1) for (q in 1:4) {
  azcurrent.aic <- AIC(arima(amzn, order=c(p, d, q)))
  if (azcurrent.aic < azfinal.aic) {
     azfinal.aic <- azcurrent.aic
     azfinal.order <- c(p, d, q)
     azfinal.arima <- arima(amzn, order=azfinal.order)
  }
}

#use the original data to analyze
amzn<-C1(AMZN)
azfinal.aic<-Inf
azfinal.order<-c(0,0,0)

#loop to find the best arima mode with best parameters (p,d,q)
for (p in 1:4) for (d in 0:1) for (q in 1:4) {
  azcurrent.aic <- AIC(arima(amzn, order=c(p, d, q)))
  if (azcurrent.aic < azfinal.aic) {
    azfinal.aic <- azcurrent.aic
    azfinal.order <- c(p, d, q)
    azfinal.arima <- arima(amzn, order=azfinal.order)
  }
}

#evaluate the forecast result by a plot and Box_test
acf(resid(azfinal.arima), na.action=na.omit)
#calculate a value
Box.test(resid(azfinal.arima, lag=20, type="Ljung-Box"))

#forecast future values
require(forecast)
plot(forecast(azfinal.arima, h=20))


#analysis on SP500 index
getSymbols("^GSPC", from="2013-01-01")
sp = diff(log(Cl(GSPC)))

spfinal.aic<-Inf
spfinal.order<-c(0,0,0)

#loop to find the best arima mode with best parameters (p,d,q)
for (p in 1:4) for (d in 0:1) for (q in 1:4) {
  spcurrent.aic <- AIC(arima(sp, order=c(p, d, q)))
  if (spcurrent.aic < spfinal.aic) {
    spfinal.aic <- spcurrent.aic
    spfinal.order <- c(p, d, q)
    spfinal.arima <- arima(sp, order=spfinal.order)
  }
}

#evaluate the forecast result by a plot and Box_test
acf(resid(spfinal.arima), na.action=na.omit)
#calculate a value
Box.test(resid(spfinal.arima), lag=20, type="Ljung-Box")
plot(forecast(spfinal.arima, h=20))


###################################################
#calculate Security real-time quota data
###################################################
setwd("D:\\R_edu\\data")
quotaData<-read.csv(file="quotaSwap_300.txt", sep=",", quote="'")
quota = diff(log(quotaData$TCLOSE))

quotaFinal.aic<-Inf
quotaFinal.order<-c(0,0,0)

#loop to find the best arima mode with best parameters (p,d,q)
for (p in 1:4) for (d in 0:1) for (q in 1:4) {
  quotaCurrent.aic <- AIC(arima(quota, order=c(p, d, q)))
  if (quotaCurrent.aic < quotaFinal.aic) {
    quotaFinal.aic <- quotaCurrent.aic
    quotaFinal.order <- c(p, d, q)
    quotaFinal.arima <- arima(quota, order=quotaFinal.order)
  }
}

#evaluate the forecast result by a plot and Box_test
acf(resid(quotaFinal.arima), na.action=na.omit)
#calculate a value
Box.test(resid(quotaFinal.arima), lag=20, type="Ljung-Box")
plot(forecast(quotaFinal.arima, h=20))


#connect to gbase 8a
install.packages( "RODBC" );
library("RODBC");
conn=odbcConnect('data8a', uid="gbase", pwd="gbase");

quota2050.all<-sqlQuery(conn, "select * from utf.TQ_QT_FUTURE  where secode='2050004210'")
quota2050<-quota2050.all$TCLOSE
quota2050Final.aic<-Inf
quota2050Final.order<-c(0,0,0)

#loop to find the best arima mode with best parameters (p,d,q)
for (p in 1:4) for (d in 0:1) for (q in 1:4) {
  quota2050Current.aic <- AIC(arima(quota2050, order=c(p, d, q)))
  if (quota2050Current.aic < quota2050Final.aic) {
    quota2050Final.aic <- quota2050Current.aic
    quota2050Final.order <- c(p, d, q)
    quota2050Final.arima <- arima(quota2050, order=quota2050Final.order)
  }
}

#evaluate the forecast result by a plot and Box_test
acf(resid(quota2050Final.arima), na.action=na.omit)
#calculate a value
Box.test(resid(quota2050Final.arima), lag=20, type="Ljung-Box")
plot(forecast(quota2050Final.arima, h=20))


