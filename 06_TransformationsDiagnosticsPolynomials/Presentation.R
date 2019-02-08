## Poisson Regression
X = rnorm(mean=100, 10000)
beta = 2
LinearY = X*2 + rnorm(10000, sd=0.1)


plot(X, LinearY)

PoissonY = rpois(10000, LinearY)
plot(X, PoissonY, col='red')

mean(PoissonY)
sd(PoissonY)

plot(X, sqrt(PoissonY), col='red')


## Random Effect
library(lme4)

model = lmer(iris$Sepal.Length ~ iris$Sepal.Width | iris$Species)
summary(model)
