library(tidyverse)
library(rstan)

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


## Bayesian Modeling
# NE = dim(TitanicTrain)[1]; 

BayesianData = list(SEX = TitanicTrain$Sex,
                    FARE = TitanicTrain$Fare, 
                    SURVIVAL = TitanicTrain$Survived)
FitBayesianModel = stan(file = "../Dropbox/2019Winter/Regression/week05/SexFareSurvival.stan",
                        data = BayesianData, iter=2000, chains=1, verbose=TRUE)
ExtBayesianModel = extract(FitBayesianModel, permuted = TRUE)

