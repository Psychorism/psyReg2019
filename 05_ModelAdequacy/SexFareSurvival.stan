// Bayesian Multiple Regerssion
data{
  int SEX;
  real FARE;
  int SURVIVAL;
}

parameters {
  real<lower = 0, upper = 1> theta_sex;
  real mu_fare;
  real<lower = 0> sigma_fare;

  real theta_survival;
  real xi_Sex;
  real psi_Sex;
  real psi_Fare;
}

model {
  SEX ~ bernoulli(theta_sex);
  FARE ~ lognormal(mu_fare + xi_Sex*SEX, sigma_fare);
  SURVIVAL ~ bernoulli(theta_survival + psi_Sex*SEX + psi_Fare*FARE);
}
