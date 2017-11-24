# includ data set
data(mtcars)
# check the first 6 lines data
head(mtcars)
tail(mtcars)
#***************************************************************
# dataframe拆分、合并
#按行拆分
a<-mtcars[c(1:6),]
b<-mtcars[c(-1:-6),]

# 数据集合并，by row
print(identical(rbind(a,b),mtcars))
#[1] TRUE

#按列拆分
a<-mtcars[c(1:3)]
b<-mtcars[c(-1:-3)]
# 数据集合并，by col
print(identical(cbind(a,b),mtcars))
#[1] TRUE
#***************************************************************
data(iris)
alist<-split(iris,iris$Species)# 按某一列拆分

alist<-subset(iris, iris$Species == "setosa") #按条件提取子集

a<-data.frame(id = c(1:3),name=c("a","b","c"))
b<-data.frame(id =c(1:3),sex = c("m","m","f"))
c<-merge(a,b,by="id")

d<-data.frame(id = c(1:2),score=c(100,60))
c<-merge(c,d,by="id") #非空子集

c<-merge(a,b,by="id")
c<-merge(c,d,by="id",all.x = TRUE,all.y = TRUE) #全集，补NA

#***************************************************************
which(iris$Species == "setosa") #return row id
which.max(iris$Sepal.Length) #return max value in col
which.min(iris$Sepal.Length) #return min value in col

#***************************************************************
a<-c(1:5)
b<-c(11:15)
c<-c(21:25)
x<-data.frame(a,b,c)
x.stack<-stack(x) #转成map结构
print(x.stack)
print(x)
x<-unstack(x.stack)
