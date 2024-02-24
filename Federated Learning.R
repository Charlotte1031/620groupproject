library(readxl)
library(dplyr)
library(lubridate)
library(tidyr)

ST01 <- read_excel("620GroupData.xlsx", sheet = "01_ScreenActivity")
ST02 <- read_excel("620GroupData.xlsx",sheet = '02_ScreenActivity')
ST03 <- read_excel("620GroupData.xlsx",sheet = '03_ScreenActivity')

ST<- rbind(ST01,ST02,ST03)

ST$Use.per.Pickup = round(ST$Use.per.Pickup,digits = 1)


ST$Pickup.1st <- as.POSIXct(ST$Pickup.1st, format = "%H:%M", tz = "UTC")
ST$Hour <- hour(ST$Pickup.1st)
ST$Minute <- minute(ST$Pickup.1st)
ST$Pickup.Time <- circular((hour(ST$Pickup.1st)*60 + minute(ST$Pickup.1st)) / (24*60)*360)
ST$Pickup.Time <- as.circular(ST$Pickup.Time, type = "angles", units = "degrees")
ST$Pickup.Time
Y = 'Social.ST.min'
X1 = 'Daily.Course.min'
X2 = 'Weather'
X3 = 'Snow'
X4 = 'Use.per.Pickup'
X5 = 'Pickup.Time'
ST <- ST %>%
  select(Y,X1,X2,X3,X4,X5) %>%
  mutate_all(~ifelse(is.na(.), median(., na.rm = TRUE), .))

ST$Pickup.Time = round(ST$Pickup.Time,digits = 1)

df <- ST

# Oracle solution
m <- lm(Social.ST.min ~ Daily.Course.min + Weather + Snow+ Use.per.Pickup+Pickup.Time, data = df)
summary(m)

dfX = as.matrix(cbind(1,ST[c(X1,X2,X3,X4,X5)]))
dfY = as.matrix(ST[Y])
SSX = t(dfX) %*% dfX
SSXY = t(dfX) %*% dfY
SSY <- t(dfY) %*% dfY
SST = t(dfY-mean(dfY)) %*% (dfY-mean(dfY))
Ybar = mean(dfY)
n = nrow(ST)
p = length(SSXY)

beta_0 = solve(SSX) %*% SSXY
SSR = SSY - 2*t(beta_0) %*% SSXY + t(beta_0) %*% SSX %*% beta_0
R_sq_0 = 1 - (SSR/(n-p))/(SST/(n-1))
R_sq_0


# Federated Statistical Learning

SSX1 <- read.csv('01_SSX.csv')
SSXY1 <- read.csv('01_SSXY.csv')
SSX2 <- read.csv('02_SSX.csv')
SSXY2 <- read.csv('02_SSXY.csv')
SSX3 <- read.csv('03_SSX.csv')
SSXY3 <- read.csv('03_SSXY.csv')
SSXY_tot = as.matrix(SSXY1) + as.matrix(SSXY2) + as.matrix(SSXY3)
SSX_tot = as.matrix(SSX1) + as.matrix(SSX2)+ as.matrix(SSX3)

n1 <- as.numeric(read.csv('01_n.csv'))
n2 <- as.numeric(read.csv('02_n.csv'))
n3 <- as.numeric(read.csv('03_n.csv'))

n_tot = (n1+n2+n3)


SSY1 <- read.csv('01_SSY.csv')
SSY2 <- read.csv('02_SSY.csv')
SSY3 <- read.csv('03_SSY.csv')
SSY_tot = SSY1 + SSY2 + SSY3

SST1 <- read.csv('01_SST.csv')
Ybar1 = SST1[2]
SST2 <- read.csv('02_SST.csv')
Ybar2 = SST2[2]
SST3 <- read.csv('03_SST.csv')
Ybar3 = SST3[2]
Ybar_tot = Ybar1*(n1/n_tot) + Ybar2*(n2/n_tot) + Ybar3*(n3/n_tot)
SST_tot = SST1[1] + SST2[1] + SST3[1] + n1*((Ybar1-Ybar_tot)^2) + n2*((Ybar2-Ybar_tot)^2) + n3*((Ybar3-Ybar_tot)^2)

beta = solve(SSX_tot) %*% SSXY_tot
SSR_tot = SSY_tot - 2*t(beta) %*% SSXY_tot + t(beta) %*% SSX_tot %*% beta
R_sq = 1 - (SSR_tot/(n_tot-p))/(SST_tot/(n_tot-1))
R_sq

sigma_square_hat = SSR_tot / (n_tot - p)

se_hat_1 = sqrt(sigma_square_hat*diag(solve(SSX_tot))[1])
se_hat_2 = sqrt(sigma_square_hat*diag(solve(SSX_tot))[2])
se_hat_3 = sqrt(sigma_square_hat*diag(solve(SSX_tot))[3])
se_hat_4 = sqrt(sigma_square_hat*diag(solve(SSX_tot))[4])
se_hat_5 = sqrt(sigma_square_hat*diag(solve(SSX_tot))[5])
se_hat_6 = sqrt(sigma_square_hat*diag(solve(SSX_tot))[6])

t1 = as.numeric(beta[1]/se_hat_1)
t2 = as.numeric(beta[2]/se_hat_2)
t3 = as.numeric(beta[3]/se_hat_3)
t4 = as.numeric(beta[4]/se_hat_4)
t5 = as.numeric(beta[5]/se_hat_5)
t6 = as.numeric(beta[6]/se_hat_6)

p1 = 2 * (1 - pt(abs(t1), df = df_p))
p2 = 2 * (1 - pt(abs(t2), df = df_p))
p3 = 2 * (1 - pt(abs(t3), df = df_p))
p4 = 2 * (1 - pt(abs(t4), df = df_p))
p5 = 2 * (1 - pt(abs(t5), df = df_p))
p6 = 2 * (1 - pt(abs(t6), df = df_p))

AIC = n_tot*log(SSR_tot)+2*p


