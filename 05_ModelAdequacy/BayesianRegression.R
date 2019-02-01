library(rstan)

Dataset = read.csv("../Dropbox/2019Winter/Regression/Dataset/MPV/delivery.csv")

## Standard Linear Regression
Model   = lm(distance ~ time + cases, Dataset)
sumModel = summary(Model)

sumModel$coefficients
sumModel$sigma

## Bayesian Linear Regression
NE = dim(Dataset)[1]; numVars = dim(Dataset[,2:3])[2]
BayesianData = list(N = NE, K = numVars, X0 = data.matrix(Dataset[, 2:3]),
                     y = Dataset$distance)
FitBayesianModel = stan(file = "../Dropbox/2019Winter/Regression/week05/BayesianMultipleRegression.stan",
                        data = BayesianData, iter=1000, chains=1, verbose=TRUE)
ExtBayesianModel = extract(FitBayesianModel, permuted = TRUE)

apply(ExtBayesianModel$Beta, 2, mean)
mean(ExtBayesianModel$sigma) 

### about 1000 iterations..