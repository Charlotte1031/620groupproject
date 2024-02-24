library(readxl)
library(dplyr)
library(lubridate)
library(tidyr)

ST <- read_excel("620GroupData.xlsx", sheet = "02_ScreenActivity")

ST$Pickup.1st <- format(ST$Pickup.1st, format = "%H:%M")
ST$Use.per.Pickup <- ST$Total.ST.min / ST$Pickups
ST$Pickup.1st <- as.POSIXct(ST$Pickup.1st, format = "%H:%M", tz = "UTC")
ST$Hour <- hour(ST$Pickup.1st)
ST$Minute <- minute(ST$Pickup.1st)
ST$Pickup.Time <- circular((hour(ST$Pickup.1st)*60 + minute(ST$Pickup.1st)) / (24*60)*360)
ST$Pickup.Time <- as.circular(ST$Pickup.Time, type = "angles", units = "degrees")

Y = 'Social.ST.min'
X1 = 'Daily.Course.min'
X2 = 'Weather'
X3 = 'Snow'
X4 = 'Use.per.Pickup'
X5 = 'Pickup.Time'

ST <- ST %>%
  select(Y,X1,X2,X3,X4,X5) %>%
  mutate_all(~ifelse(is.na(.), median(., na.rm = TRUE), .))


dfX = as.matrix(cbind(1, ST[c(X1,X2,X3,X4,X5)]))
dfY = as.matrix(ST[Y])
SSX = t(dfX) %*% dfX
SSXY = t(dfX) %*% dfY
SSY <- t(dfY) %*% dfY
SST = t(dfY-mean(dfY)) %*% (dfY-mean(dfY))

n = nrow(ST)

write.csv(SSX, '02_SSX.csv', row.names = FALSE)
write.csv(SSY, '02_SSY.csv', row.names = FALSE)
write.csv(SSXY, '02_SSXY.csv', row.names = FALSE)
write.csv(cbind(SST,mean(dfY)), '02_SST.csv', row.names = FALSE)
write.csv(n, '02_n.csv', row.names = FALSE)


