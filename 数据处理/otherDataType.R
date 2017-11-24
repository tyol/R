#因子型数据使用举例
sex<-factor("m",c("m","f"))
#替换类型
levels(sex)<-c("male","female")
print(sex)
#有序因子
alphab<-ordered("a",c("a","b","c"))
print(alphab)
