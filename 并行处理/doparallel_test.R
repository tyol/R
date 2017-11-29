
func <- function(x){
  return (x+1);
}

#加载foreach
library(foreach)

#下面这行代码相当于sapply
#.combine则表示运算结果的整合方式，常用的操作符有c, rbind, cbind, +, *。注意，+ 和 * 是list的同列操作。
system.time({
x <- foreach(x=1:1000,.combine='rbind') %do% func(x)
})

# 启用parallel作为foreach并行计算的后端
library(doParallel)
cl <- makeCluster(4)
registerDoParallel(cl)

# 并行计算方式
system.time({
x <- foreach(x=1:1000,.combine='rbind') %dopar% func(x)
})
#别忘了结束并行
stopCluster(cl)