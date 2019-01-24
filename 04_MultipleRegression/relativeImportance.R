library(tidyverse)
library(relaimpo)

Titanic = read.csv("../Dropbox/2019Winter/Regression/Dataset/Titanic/train.csv")
set.seed(1234)

numRows = dim(Titanic)[1]
trainIndx = sample(1:numRows, round(numRows*.7,0), replace = F)

TitanicTrain = Titanic[trainIndx,]
TitanicTest  = Titanic[-trainIndx,]

## Drop variables
TitanicTrain$Cabin = NULL
TitanicTest$Cabin = NULL

TitanicTrain$Name = NULL
TitanicTest$Name = NULL

TitanicTrain$Ticket = NULL
TitanicTest$Ticket = NULL

TitanicTrain$PassengerId = NULL
TitanicTest$PassengerId = NULL

## Interpolation
sum(is.na(TitanicTrain$Age))

LinModelForInterp = lm(Age ~., TitanicTest)
MissingAges = TitanicTrain[is.na(TitanicTrain$Age), ]
MissingAges$Age = NULL
PredictedAges = predict(LinModelForInterp, MissingAges)
TitanicTrain[is.na(TitanicTrain$Age), ]$Age = PredictedAges

TitanicTrain$Sex = as.numeric(TitanicTrain$Sex)-1
TitanicTrain$Embarked = as.numeric(TitanicTrain$Embarked)

## Relative Importance
Model = lm(Survived ~., TitanicTrain)
Model$coefficients[2:7] %>% barplot

metrics = calc.relimp(Model, type = c("lmg", "first", "last", "betasq", "pratt"))

metrics$first %>% barplot
metrics$last %>% barplot
metrics$lmg %>% barplot
metrics$betasq %>% barplot
