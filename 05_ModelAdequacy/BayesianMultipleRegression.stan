// Bayesian Multiple Regerssion
data{
  int<lower = 1> N;
  int<lower = 1> K;
  matrix[N, K] X0;
  vector[N] y;
}

transformed data{
 vector[N] x0;
 matrix[N, K+1] X;

 x0 = rep_vector(1,N);
 X  = append_col(x0, X0);
}

parameters {
  vector[K+1] Beta;
  real<lower = 0> sigma_sq;
}

transformed parameters {
 real<lower=0> sigma;
 sigma = sqrt(sigma_sq);
}

model {
  y ~ normal(X * Beta, sigma);
}
