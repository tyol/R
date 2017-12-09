#************************************
# this file will show basic lr function
#************************************

#get the current path
path <- getwd()
#add test data
df <- read.csv("D:\\workshop\\R\\????ѧϰ?㷨\\test_data\\generateData.csv")


lmloop<-function(df)
{
  #remove record has NA value
  df<-na.omit(df)
  
  #build the formula string
  if (length(df) == 2){
    f<-as.formula(paste(names(df)[1],names(df)[2],sep = "~"))
  }else{
    f<-as.formula(paste(names(df)[1],paste(names(df)[-1],sep = "",collapse = "+"),sep = "~"))
  }
  print(f)
  
  #train the lm model
  lm.model<-lm(f,data = df)
  
  #print result of lm model
  lm.model.result<-summary(lm.model)
  print(lm.model.result)
  
  #check the model target
  lm.model.rsquraed<-lm.model.result$r.squared
  p.value<-(1-pf(lm.model.result$fstatistic[1],lm.model.result$fstatistic[2],lm.model.result$fstatistic[3]))
  
  #evaluate the model
  if (p.value<0.01){
    if((lm.model.rsquraed>0.3) & (lm.model.rsquraed<0.6)){
      print("***********************************")
      print("this combination is good with lm")
      print(f)
      print(paste("r squraed: ",lm.model.rsquraed))
      print(paste("p-value: ",p.value))
    }else if((lm.model.rsquraed>=0.6) & (lm.model.rsquraed<0.8)){
      print("***********************************")
      print("this combination is very good with lm")
      print(f)
      print(paste("r squraed: ",lm.model.rsquraed))
      print(paste("p-value: ",p.value))
    }else if(lm.model.rsquraed>=0.8){
      print("***********************************")
      print("this combination is so good with lm")
      print(f)
      print(paste("r squraed: ",lm.model.rsquraed))
      print(paste("p-value: ",p.value))
    }else{
      print("***********************************")
      print("this combination is not fitted with lm")
      print(f)
    }
    
  }else{
    print("***********************************")
    print("this combination is not fitted with lm")
    print(f)
  }
  #end of evaluate
  out<-list(pv<-c(p.value),rsq<-c(lm.model.rsquraed),drawOutRelationSet(names(df),lm.model.result))
  
  return(out)
} # end of function lmloop

#draw out the relation set from the lm model
drawOutRelationSet<-function(nameList,lm.model.result)
{
  out<-list()
  out<-append(out,nameList[1])
  for (i in c(2:(length(nameList)-1))){
    if (lm.model.result$coefficients[i,4]<0.05){
    out<-append(out,nameList[i+1])
    }
  }
  return(out)
}

# get the predict value from new database
lm.predict<-predict(lm.model,df[,-1])
plot(df[,1],lm.predict)
abline(0,1)

# get the train set predict data, and follow the degree of freedom
lm.fitted<-fitted(lm.model)
plot(df[,1],lm.fitted)
abline(0,1)

#keep the col3+col5+col7 with 1:1:1
#keep the col10+col12+col14 with 1:1:1
f<-as.formula("col1~I(col3+col5+col7)+I(col10+col12+col14)")
lm.mode2 <- lm(f,df)
              
summary(lm.mode2)
#other function can be used in the lm: log, exp, sqrt and so on.
