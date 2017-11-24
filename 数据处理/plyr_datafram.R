install.packages("plyr")

library(plyr)

#直接合并原始数据和结果
result<-adply(iris,
      1, # 行计算，2 列计算
      function(row){
        data.frame(flag=c(row$Sepal.Length>=5)) #注意使用等号
      })
head(result)

#先分类，在计算
result<-ddply(iris,
      .(Species),  #分类条件
      function(sub){
        data.frame(width.mean=mean(sub$Sepal.Width))
      }
      )
#Species width.mean
#1     setosa      3.428
#2 versicolor      2.770
#3  virginica      2.974

#transform
#mutate
#summarise
#subset
#mdply

