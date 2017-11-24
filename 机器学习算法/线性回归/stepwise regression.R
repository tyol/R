#step wist lr

#add test data
df <- read.csv("D:\\workshop\\R\\机器学习算法\\test_data\\generateData.csv")

f<-as.formula("col1 ~ col2 + col3 + col4 + col5 + col6 + col7 + col8 + col9 + 
    col10 + col11 + col12 + col13 + col14 + col15 + col16")

lm.model<-lm(f,data = df)
summary(lm.model)

tstep<-step(lm.model)
summary(tstep)

# 前进法
fstep<-step(lm.model,direction="forward")
summary(fstep)

#后退法
fstep<-step(lm.model,direction="backward")
summary(fstep)

#与lmloop结果继续比较，step wise方法得到的r squared更好，但会有线性关系差的因子。
f<-as.formula("col1 ~ col3 + col5 + col7 + col10 + col12 + col14")
lm.model<-lm(f,data = df)
summary(lm.model)
