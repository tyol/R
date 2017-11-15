library("RODBC")

myconn<-odbcConnect("r_dataset",uid = "root", pwd = "111111") #创建连接
sqlTables(myconn)   #显示所有的表

data(USArrests)

sqlSave(myconn,USArrests,rownames = "state",addPK = TRUE)#将dataframe中的数据写入ODBC数据库

t_test<-sqlQuery(myconn,"select * from test")    #执行查询后的结果存入t_test
t_iris<-sqlQuery(myconn,"select * from iris")    #执行查询后的结果存入t_iris
t_USArrests<-sqlQuery(myconn,"select * from usarrests")    #执行查询后的结果存入t_usarrests
sqlFetch(myconn,"USArrests")    #读取表内全部数据

sqlDrop(myconn,"USArrests")    #删除表

odbcClose(myconn)    #关闭ODBC连接

