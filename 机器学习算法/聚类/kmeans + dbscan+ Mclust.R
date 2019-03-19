setwd("D:\\data")
#这里使用河流化学成份对有害藻类影响的数据集
vdata=read.csv("algpre.csv")
#进行kmeans聚类前，需要进行标准化处理，这里使用scale函数进行标准化
data=scale(vdata[,c("mxPH","mnO2")])

##################################KMEANS####################################
library(fpc)
pamk.result=pamk(data)#使用fpc包中的pamk函数，确定聚类个数
class(data)
kmd=kmeans(data,centers=pamk.result$nc,iter.max=100)
kmd
data_k=cbind.data.frame(data,kmd$cluster)
data_k_1 = data_k[which(data_k$`kmd$cluster`==1),]

plot(data_k[c(1,2)],col=data_k$`kmd$cluster`,main="kmeans聚类分析",xlab = "mxPH",ylab="mnO2")
points(kmd$centers,col = 1:pamk.result$nc,pch = 8, cex=2)

##################################DBSCAN####################################
library(fpc)
ds<-dbscan(data, eps=0.4,MinPts=10,scale=F, showplot=TRUE,countmode=NULL, method="raw")
ds
ds<-dbscan(data, eps=0.4,MinPts=5,scale=F, showplot=TRUE,countmode=NULL, method="raw")
ds
plot(ds,data,main="dbscan聚类分析",xlab = "mxPH",ylab="mnO2")

ds_d<-cbind.data.frame(data,ds$isseed)
ds_d_isnotseed <- ds_d[which(!ds_d$`ds$isseed`),]

###############################EM##########################################
library(mclust)
mr = Mclust(data)
summary(mr)
summary(mr,parameters = TRUE)
mr_m=cbind.data.frame(data,mr$classification)

mclust2Dplot(data,parameters = mr$parameters,z=mr$z,what = "classification",main = TRUE)

mclust2Dplot(data,parameters = mr$parameters,z=mr$z,what = "uncertainty",main = TRUE)

m_den = densityMclust(data)
plot(m_den,data,col="cadetblue",nlevels=25,what = "density")
plot(m_den,what = "density",type="persp",theta=235)


