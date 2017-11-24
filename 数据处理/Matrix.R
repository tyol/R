#**********************************************
d<-matrix(1:9,ncol = 3)
print(d)
#各列求和
apply(d,1,sum)
#求奇偶
ifelse(d%%2,1,0)

#sapply,lapply,tapply,mapply返回数据类型不同