library(MASS)
source("BDS_Functions.R")

boston <- Boston[, c("medv", "lstat", "rm")]
attach(boston)

set.seed(0319)
randomNumbers <- sample(1:nrow(boston), nrow(boston)/2)
train <- boston[randomNumbers, ]
test <- boston[-randomNumbers, ]

#Boosted Decision Stump Implementation
#This function takes train data, test data, label name, learning rate and number of trees as input arguments
#Outputs the predictions for the test set
boost.dStump <- function(train.data, test.data, label.name, learn.rate, trees) {
  
  res <- train.data
  predictions.train <- 0
  predictions.test <- 0
  best.values <- list()
  
  for (i in 1:trees) {
    
    best.values <- d.stump(res, "medv")
    preds.perTree.Train <- ifelse(res[, best.values$feature] < best.values$split, best.values$meanlT, best.values$meangT)
    
    fhat <- preds.perTree.Train
    res[, label.name] <- (res[, label.name] - (learn.rate * fhat))
    
    preds.perTree.Test <- ifelse(test[, best.values$feature] < best.values$split, best.values$meanlT, best.values$meangT)
    fhat.test <- preds.perTree.Test
    predictions.test <- predictions.test + (learn.rate * fhat.test)
    
  }
  return(predictions.test)
}

#Train the BDS implementation for 1000 trees and η = 0.01
predictions.test <- boost.dStump(train, test, "medv", .01, 1000)

#Calculate the test MSE
test.MSE <- sum((test[, "medv"] - predictions.test)^2)/nrow(test)

