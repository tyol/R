library(sqldf)
data("AMSsurvey")
head(AMSsurvey)

sqldf("select count(*) from AMSsurvey")
sqldf("select distinct sex from AMSsurvey")
sqldf("select * from AMSsurvey where sex = 'Male'")
