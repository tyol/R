#���ذ�
library(e1071)
help(package="e1071")
#�������ݼ�
setwd("D:\\R_edu\\data")
orgData<-read.csv("date_data2.csv")

#�鿴�Ƿ����ȱʧֵ
summary(orgData)

#��ȡ�����ֶν��н�ģ
orgData1=orgData[,c("income","attractive","assets","edueduclass","Dated")]
orgData1$edueduclass=as.factor(orgData1$edueduclass)
orgData1$Dated=as.factor(orgData1$Dated)

#����ѵ�����Ͳ��Լ�
set.seed(110)
select<-sample(1:nrow(orgData1),length(orgData1$Dated)*0.6)
train=orgData1[select,]
test=orgData1[-select,]
train.y=orgData1[select,5]
test.y=orgData1[-select,5]



#ʹ��svm����������֧��������ģ��
svm.mod<-svm(Dated~income+attractive+assets+edueduclass,kernel="radial",
             data=train,probability=TRUE,cost=0.1,gamma=0.4,cross=10)
summary(svm.mod)

#������svmģ���У����������Ĺ�ϵͼ
svm.mod<-svm(Dated~attractive+assets,kernel="radial",
             data=train,probability=TRUE,cost=0.1,gamma=0.4,cross=10)
plot(x=svm.mod,data=train,formula=assets~attractive,svSymbol = "x", dataSymbol = "o")
plot(x=svm.mod,data=train,formula=assets~income,svSymbol = "x", dataSymbol = "o")
plot(x=svm.mod,data=train,formula=income~attractive,svSymbol = "x", dataSymbol = "o")

?plot.svm
#����������Ԥ��
y_hat=predict(svm.mod,orgData1,probability=F)

#�ٻ��ʺ;�ȷ��
require(gmodels)
t<-CrossTable(x =orgData1$Dated, y = y_hat,prop.chisq=FALSE)
t$prop.row[2,2]#�ٻ���
t$prop.col[2,2]#��ȷ��

########################################################################################
#ѡ������ģ�Ͳ���
require(gmodels)
ROC<-data.frame()
for (i in seq(from =0.1,to =10,by =0.5)){
  svm.mod<-svm(Dated~income+attractive+assets+edueduclass,kernel="polynomial",
               data=train,probability=TRUE,cost=i,gamma=0.4,cross=10)
  y_hat=predict(svm.mod,test,probability=F)
  t<-CrossTable(x =test.y, y = y_hat,prop.chisq=FALSE)
  accuracy<-sum(y_hat==test.y)/length(test.y)#׼ȷ��
  out<-data.frame(i,accuracy,t$prop.row[2,2],t$prop.col[2,2])
  ROC<-rbind(ROC,out)
}
names(ROC)<-c("n","accuracy","Recall","Precision")
