#将数据集分成n份，然后进行测试集和训练集的设置
library(cvTools)
data(iris)
df<-iris

cv<-cvFolds(NROW(df),K = 10, R = 3) #type = "consecutive"

for(i in c(1:cv$R)){
  validation_idx<-cv$subsets[which(cv$which == i), 1]
  trainSet <- df[-validation_idx,]
  validationSet<-df[validation_idx,]
  print(trainSet)
  print(validationSet)
}



library(foreach)

func <- function(x){
  validation_idx<-cv$subsets[which(cv$which == x), 1]
  trainSet <- df[-validation_idx,]
  validationSet<-df[validation_idx,]
  #print(trainSet)
  #print(validationSet)
  return (cbind(t=NROW(trainSet),v=NROW(validationSet)));
}


x <- foreach(x=1:cv$R,.combine='rbind') %do% func(x)
