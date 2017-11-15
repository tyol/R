library(RJDBC)

drv <- JDBC("com.mysql.jdbc.Driver","E:/JDBC/mysql-connector-java-5.1.44-bin.jar")
conn <- dbConnect(drv,"jdbc:mysql://localhost/r_dataset","root","111111")
dbListTables(conn)

#write data to database
data(iris)
a<-iris
colnames(a)<-chartr(".","_",names(iris))
dbWriteTable(conn,"iris", a, overwrite=TRUE)
#（append=TRUE追加,dbWriteTable(conn,"IRIS",d,overwrite=FALSE,append=TRUE)且d要与表iris的结构一致。）  

#check the write result
if (dbExistsTable(conn,"iris") == TRUE) {
  dbGetQuery(conn,"select count(*) from iris")
  dbGetQuery(conn,"select * from iris")
}

#check test table
dbListTables(conn)
if (dbExistsTable(conn,"test") == TRUE) {
  c=c(1:10)
  dbGetQuery(conn,"show create table test")
  dbWriteTable(conn,"test",c)
}

#dbRemoveTable(conn,”iris”)：删除表iris

#close connect
dbDisconnect(conn)
