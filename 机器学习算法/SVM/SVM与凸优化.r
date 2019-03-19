#加载包
library(e1071)
help(package="e1071")
#加载数据集
setwd("D:\\R_edu\\data")
orgData<-read.csv("date_data2.csv")

#查看是否存在缺失值
summary(orgData)

#提取如下字段进行建模
orgData1=orgData[,c("income","attractive","assets","edueduclass","Dated")]
orgData1$edueduclass=as.factor(orgData1$edueduclass)
orgData1$Dated=as.factor(orgData1$Dated)

#构建训练集和测试集
set.seed(110)
select<-sample(1:nrow(orgData1),length(orgData1$Dated)*0.6)
train=orgData1[select,]
test=orgData1[-select,]
train.y=orgData1[select,5]
test.y=orgData1[-select,5]



#使用svm函数，建立支持向量机模型
svm.mod<-svm(Dated~income+attractive+assets+edueduclass,kernel="radial",
             data=train,probability=TRUE,cost=0.1,gamma=0.4,cross=10)
summary(svm.mod)

#画出在svm模型中，两个变量的关系图
svm.mod<-svm(Dated~attractive+assets,kernel="radial",
             data=train,probability=TRUE,cost=0.1,gamma=0.4,cross=10)
plot(x=svm.mod,data=train,formula=assets~attractive,svSymbol = "x", dataSymbol = "o")
plot(x=svm.mod,data=train,formula=assets~income,svSymbol = "x", dataSymbol = "o")
plot(x=svm.mod,data=train,formula=income~attractive,svSymbol = "x", dataSymbol = "o")

?plot.svm
#在新数据做预测
y_hat=predict(svm.mod,orgData1,probability=F)

#召回率和精确度
require(gmodels)
t<-CrossTable(x =orgData1$Dated, y = y_hat,prop.chisq=FALSE)
t$prop.row[2,2]#召回率
t$prop.col[2,2]#精确度

########################################################################################
#选择最优模型参数
require(gmodels)
ROC<-data.frame()
for (i in seq(from =0.1,to =10,by =0.5)){
  svm.mod<-svm(Dated~income+attractive+assets+edueduclass,kernel="polynomial",
               data=train,probability=TRUE,cost=i,gamma=0.4,cross=10)
  y_hat=predict(svm.mod,test,probability=F)
  t<-CrossTable(x =test.y, y = y_hat,prop.chisq=FALSE)
  accuracy<-sum(y_hat==test.y)/length(test.y)#准确率
  out<-data.frame(i,accuracy,t$prop.row[2,2],t$prop.col[2,2])
  ROC<-rbind(ROC,out)
}
names(ROC)<-c("n","accuracy","Recall","Precision")
