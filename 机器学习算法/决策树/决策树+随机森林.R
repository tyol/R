#加载数据集
setwd("D:\\R_edu\\data")
orgData<-read.csv("date_data2.csv")

orgData<-orgData[,c(1,2,3,4,5)]
orgData$Dated<-as.factor(orgData$Dated)
orgData$edueduclass<-as.factor(orgData$edueduclass)
attach(orgData)

set.seed(10)
select<-sample(1:nrow(orgData),length(orgData$Dated)*0.8)
train=orgData[select,]
test=orgData[-select,]
summary(train$Dated)
###################################
## Section 1: CART算法(分类树)
###################################
#1.建立CART模型(依然使用原数据集)
##建模
#CART在R中的实现
#rpart包中有针对CART决策树算法提供的函数，比如rpart函数
#以及用于剪枝的prune函数
#rpart函数的基本形式：rpart(formula,data,subset,na.action=na.rpart,method.parms,control,...)
library(rpart)
#1.建立CART模型
#1.1 设置前向剪枝的条件
tc <- rpart.control(minsplit=2,minbucket=2,maxdepth=10,xval=10,cp=0.001)
## rpart.control对树进行一些设置  
## minsplit是最小分支节点数，这里指大于等于2，那么该节点会继续分划下去，否则停止  
## minbucket：树中叶节点包含的最小样本数  
## maxdepth：决策树最大深度 
## xval:交叉验证的次数
## cp全称为complexity parameter，指某个点的复杂度，对每一步拆分,模型的拟合优度必须提高的程度  
#1.2 建模
rpart.mod=rpart(Dated ~.,data=train,method="class",control=tc)
summary(rpart.mod)
#1.3看变量重要性
rpart.mod$variable.importance
#cp是每次分割对应的复杂度系数
rpart.mod$cp
plotcp(rpart.mod)

library(rpart.plot)
rpart.plot(rpart.mod,branch=1, extra=106, under=TRUE, faclen=0,
           cex=0.8, main="决策树")
plot(rpart.mod)
text(rpart.mod,all=TRUE,digits=7,use.n=TRUE,cex=0.9,xpd=TRUE)

#2.cart剪枝方法
#prune函数可以实现最小代价复杂度剪枝法，对于CART的结果，每个节点均输出一个对应的cp
#prune函数通过设置cp参数来对决策树进行修剪,cp为复杂度系数
## 我们可以用下面的办法选择具有最小xerror的cp的办法：  
rpart.mod.pru<-prune(rpart.mod, cp= rpart.mod$cptable[which.min(rpart.mod$cptable[,"xerror"]),"CP"]) 
rpart.mod.pru$cp

#3.绘制rpart.mod.pru的树状图
##### 第一种
plot(rpart.mod.pru)
text(rpart.mod.pru,all=TRUE,digits=7,use.n=TRUE,cex=0.9,xpd=TRUE)
##### 第二种，这种会更漂亮一些
library(rpart.plot)
rpart.plot(rpart.mod.pru,branch=1, extra=106, under=TRUE, faclen=0,
           cex=0.8, main="决策树")
#4.cart预测
#使用模型对测试集进行预测
#使用模型进行预测
rpart.pred<-predict(rpart.mod.pru,test)

#可以看到，rpart.pred的结果有两列，第一列是为0的概率，第二列是为1的概率
#通过设定阀值，得到预测分类
pre<-ifelse(rpart.pred[,2]>0.5,1,0)

#也可以通过如下方式来实现
preType<-predict(rpart.mod.pru,test,type="class")
###################################
## Section 2: 随机森林(分类树)
###################################
#随机森林算法是一种专门为决策树分类器设计的优化方法，它综合了多棵决策树模型的预测结果，
#其中的每棵树都是基于随机样本的一个独立集合的值产生的
train<-na.omit(train)
library(randomForest)
rf<-randomForest(Dated~.,data=train,importance=TRUE,ntree=3)

rf$importance
varImpPlot(rf)
print(importance(rf))

pre<-predict(rf,train,type="response")
