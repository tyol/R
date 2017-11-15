library(RJDBC)

drv <- JDBC(“com.mysql.jdbc.Driver”,”E:/JDBC/mysql-connector-java-5.1.44-bin.jar”,identifier.quote="`")
conn<-dbConnect(drv,”jdbc:mysql://127.0.0.1:2223/ZJH”,"root”,"111111”)
