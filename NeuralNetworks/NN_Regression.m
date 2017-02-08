sigmoid <- function(x) {
  sig <- 1/(1 + exp(-x))
}

sigmoid.derivative <- function(x) {
  sig.derivative <- sigmoid(x) * (1 - sigmoid(x))
}
#===================================================================#
set.seed(87)
library(ISLR)
auto <- Auto[, c("horsepower", "weight", "year", "origin", "mpg")]

auto$X4 <- ifelse(auto$origin == 1, 1, 0)
auto$X5 <- ifelse(auto$origin == 2, 1, 0)
auto <- auto[ , -4]

randomNumbers <- sample(1:392, 242)
train.X <- as.matrix(auto[randomNumbers, -4])
train.Y <- auto[randomNumbers, 4]
test.X <- as.matrix(auto[-randomNumbers, -4])
test.Y <- auto[-randomNumbers, 4]

mns <- colMeans(train.X)
sds <- apply(train.X, 2, sd)
train.X <- t(apply(train.X, 1, function(x) (x-mns)/sds))
test.X <- t(apply(test.X, 1, function(x) (x-mns)/sds))
#===================================================================#

n.train <- function(train.atr, train.lbl, nodes.hL, epochs, lrn.rate) {
  
  random.alpha <- runif((nodes.hL * (ncol(train.atr) + 1)), min = -0.7, max = 0.7)
  random.beta <- runif(1 * (nodes.hL + 1), min = -0.7, max = 0.7)
  
  #Create weight matrices
  alpha <- matrix(data = random.alpha, nrow = nodes.hL, ncol = (ncol(train.atr) + 1))
  beta <- matrix(data = random.beta, nrow = 1, ncol = (nodes.hL + 1))
  
  #Add bias unit and make bias as the first column of the matrix
  train.atr <- cbind(1, train.atr)
  
  tMSE <- rep(0, epochs)
  
  for (i in 1:epochs) {
    
    #Forward Pass
    hL <- t(sigmoid(alpha %*% t(train.atr)))
    hL <- cbind(1, hL)
    
    #Training Predictions
    train.preds <- t(beta %*% t(hL))
    
    #oE = Output Error, hE = Hidden Error
    oE <- 2 * (train.lbl - train.preds)
    hE <- (oE %*% beta) * sigmoid.derivative(hL)
    
    #Delta weights
    dBeta <- t(oE) %*% hL
    dAlpha <- t(hE[, -1]) %*% train.atr
    
    #Update weights
    beta <- beta + ((lrn.rate/nrow(train.atr)) * dBeta)
    alpha <- alpha + ((lrn.rate/nrow(train.atr)) * alpha)
    
    #Keep track of Training MSE
    tMSE[i] <- sum((train.preds - train.Y)^2)/nrow(train.atr)
    
    #Plot Train MSE for each epoch
    #plot(tMSE, type = 'l', xlab = "No. of epochs", ylab = "Training MSE")
    
  }
  
  return(list("alpha" = alpha, "beta" = beta))
  
}

n.test <- function(test.atr, w) {
  
  #Add bias to the test set
  test.atr <- cbind(1, test.atr)
  
  #Calculate hidden layer values
  hL <- sigmoid(test.atr %*% t(w$alpha))
  
  #Add bias to hidden layer
  hL <- cbind(1, hL)
  
  #Calaulate output layer
  test.preds <- hL %*% t(w$beta)
  
  return(test.preds)
  
}


a <- n.train(train.X, train.Y, 4, 3500, .01)
t.preds <- n.test(test.X, a)
tMSE <- sum((t.preds - test.Y)^2)/length(test.Y)