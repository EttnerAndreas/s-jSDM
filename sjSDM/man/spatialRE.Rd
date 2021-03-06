% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sjSDM_configs.R
\name{spatialRE}
\alias{spatialRE}
\title{spatial random effects}
\usage{
spatialRE(re = NULL)
}
\arguments{
\item{re}{vector of factors or integers}
}
\description{
define spatial random effects (random intercepts for sites)
}
\examples{
\donttest{
  
# Basic workflow:
## simulate community:
com = simulate_SDM(env = 3L, species = 5L, sites = 100L)

## fit model:
model = sjSDM(Y = com$response,env = com$env_weights, iter = 2L) 
# increase iter for your own data 

coef(model)
summary(model)
getCov(model)

## calculate post-hoc p-values:
p = getSe(model)
summary(p)

## or turn on the option in the sjSDM function:
model = sjSDM(Y = com$response, env = com$env_weights, se = TRUE, family = binomial("probit"), 
              iter = 2L)
summary(model)

## fit model with interactions:
model = sjSDM(Y = com$response,
              env = linear(data = com$env_weights, formula = ~X1:X2 + X3), se = TRUE,
              iter = 2L) # increase iter for your own data 
summary(model)

## without intercept:
model = sjSDM(Y = com$response,
              env = linear(data = com$env_weights, formula = ~0+X1:X2 + X3), se = TRUE,
              iter = 2L) # increase iter for your own data 
summary(model)

## predict with model:
preds = predict(model, newdata = com$env_weights)


# With spatial terms:
## linear spatial model
XY = matrix(rnorm(200), 100, 2)
model = sjSDM(Y = com$response, env = linear(com$env_weights), 
              spatial = linear(XY, ~0+X1:X2),
              iter = 2L) # increase iter for your own data 
summary(model)
predict(model, newdata = com$env_weights, SP = XY)

## non-linear(deep neural network) model
model = sjSDM(Y = com$response, env = linear(com$env_weights), 
              spatial = DNN(XY,hidden = c(5L, 5L), ~0+.),
              iter = 2L) # increase iter for your own data 
summary(model)
predict(model, newdata = com$env_weights, SP = XY)


# Regularization
## lambda is the regularization strength
## alpha weights the lasso or ridge penalty:
## - alpha = 0 --> pure lasso
## - alpha = 1.0 --> pure ridge
model = sjSDM(Y = com$response, 
              # mix of lasso and ridge
              env = linear(com$env_weights, lambda = 0.01, alpha = 0.5), 
              # we can do the same for the species-species associations
              biotic = bioticStruct(lambda = 0.01, alpha = 0.5),
              iter = 2L) # increase iter for your own data 
summary(model)
coef(model)
getCov(model)





# Anova 
com = simulate_SDM(env = 3L, species = 15L, sites = 200L)

XY = matrix(rnorm(400), 200, 2)
model = sjSDM(Y = com$response, env = linear(com$env_weights), 
              spatial = linear(XY, ~0+X1:X2), 
              iter = 2L) # increase iter for your own data 
result = anova(model, cv = 2L)
print(result)
plot(result)


# Deep neural network
## we can fit also a deep neural network instead of a linear model:
model = sjSDM(Y = com$response,
              env = DNN(com$env_weights, hidden = c(10L, 10L, 10L)),
              iter = 2L) # increase iter for your own data 
summary(model)
getCov(model)
pred = predict(model, newdata = com$env_weights)

## extract weights
weights = getWeights(model)

## we can also assign weights:
setWeights(model, weights)

## with regularization:
model = sjSDM(Y = com$response, 
              # mix of lasso and ridge
              env = DNN(com$env_weights, lambda = 0.01, alpha = 0.5), 
              # we can do the same for the species-species associations
              biotic = bioticStruct(lambda = 0.01, alpha = 0.5),
              iter = 2L) # increase iter for your own data 
getCov(model)
getWeights(model)
}
}
\seealso{
\code{\link{sjSDM}}
}
