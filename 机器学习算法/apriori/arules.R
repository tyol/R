install.packages("arules")
install.packages("arulesViz")

library("arules")
library("arulesViz")

####从数据库读取数据
# library(RJDBC)
# drv <- JDBC(driverclass = "com.gbase.jdbc.Driver", classpath="D:\\gbase-connector-java-8.3.81.51-build1.0-bin.jar")
# conn <- dbConnect(drv, "jdbc:gbase://192.168.11.40:5258/dbname", "root")
# sql <- "select group_concat(distinct compcode separator ' ') as compcode from ta_comp_manager group by personalcode;"
# org_data <- dbGetQuery(conn, sql)
# trans_date <- as(org_data, "transactions")
# dbDisconnect(conn)

#### R自带的数据
#     items                                                                
#  [1] {citrus fruit,semi-finished bread,margarine,ready soups}             
#  [2] {tropical fruit,yogurt,coffee}  
data("Groceries")
summary(Groceries)
inspect(Groceries[1:5]) 

### 预估恰当的支持度
itemFrequency(Groceries)
itemFrequencyPlot(Groceries)


#### 调用apriori算法，得出关联规则
rules <- apriori(Groceries, parameter = list(support = 0.001, confidence = 0.5))
rules
summary(rules)
plot(rules)
plot(rules, method = "graph", jetter = rules)
# setwd("C:\\Users\\静纬\\Desktop\\证监会")
write(rules, file = "rules.csv", sep = ",")

#### 调用apriori算法，得出最大频繁项集
#多关心两个及以上事物的关联关系 故minlen = 2
maximally <- apriori(Groceries, parameter = list(support = 0.001, minlen = 2, target = "maximally frequent itemsets"))
summary(maximally)
plot(maximally)
plot(maximally, method = "graph", jetter = maximally)
#setwd("C:\\Users\\静纬\\Desktop\\证监会")
write(maximally, file = "maximally", sep = ",")



