
#加载数据集
setwd("D:\\R_edu\\data")
orgData<-read.csv("date_data2.csv")

y<-orgData[,c("Dated")]
x<-orgData[,c(1,2,3,4)]
summary(x)#经检查，没有缺失值问题

#极差标准化数据
normalize <- function(x) { 
  return((x - min(x)) / (max(x) - min(x)))
}
x<- as.data.frame(lapply(x, normalize))

data<-cbind(y,x)
data$y<-as.factor(data$y)
summary(data)
#构建训练集和测试集
set.seed(110)
select<-sample(1:nrow(data),length(data$y)*0.7)
train=data[select,-1]
test=data[-select,-1]
train.y=data[select,1]
test.y=data[-select,1]
#使用KNN算法
library(class)
y_hat<-knn(train = train,test = test,cl=train.y,k=10)


#模型验证
#准确率
accuracy.knn<-sum(y_hat==test.y)/length(test.y)
accuracy.knn
agreement_KNN<- y_hat==test.y
table(agreement_KNN)
#召回率和精确度
require(gmodels)
t<-CrossTable(x =test.y, y = y_hat,prop.chisq=FALSE)
t$prop.row[2,2]#召回率
t$prop.col[2,2]#精确度

ROC<-data.frame()
for (i in seq(from =1,to =40,by =1)){
  y_hat<-knn(train = train,test = test,cl=train.y,k=i)
  require(gmodels)
  t<-CrossTable(x =test.y, y = y_hat,prop.chisq=FALSE)
  accuracy.knn<-sum(y_hat==test.y)/length(test.y)#准确率
  #t$prop.row[2,2]#召回率
  #t$prop.col[2,2]#精确度、命中率
  out<-data.frame(i,accuracy.knn,t$prop.row[2,2],t$prop.col[2,2])
  ROC<-rbind(ROC,out)
}
names(ROC)<-c("n","accuracy","Recall","Precision")
