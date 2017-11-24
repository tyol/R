# includ data set
data(mtcars)
# check the first 6 lines data
head(mtcars)

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