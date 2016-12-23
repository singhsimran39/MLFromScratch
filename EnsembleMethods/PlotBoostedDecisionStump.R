library(MASS)
source("BDS_Functions.R")

boston <- Boston[, c("medv", "lstat", "rm")]
attach(boston)

set.seed(0319)
randomNumbers <- sample(1:nrow(boston), nrow(boston)/2)
train <- boston[randomNumbers, ]
test <- boston[-randomNumbers, ]

#Boosting Implementation
#Create decision stumps for a certain number of trees
boost.dStump <- function(train.data, test.data, label.name, learn.rate, trees) {
  
  res <- train.data
  predictions.train <- 0
  predictions.test <- 0

  for (i in 1:trees) {
    
    best.values <- d.stump(res, "medv")
    preds.perTree.Train <- ifelse(res[, best.values$feature] < best.values$split, best.values$meanlT, best.values$meangT)
    
    fhat <- preds.perTree.Train
    predictions.train <- predictions.train + (learn.rate * fhat)
    res[, label.name] <- (res[, label.name] - (learn.rate * fhat))
    
    preds.perTree.Test <- ifelse(test[, best.values$feature] < best.values$split, best.values$meanlT, best.values$meangT)
    fhat.test <- preds.perTree.Test
    predictions.test <- predictions.test + (learn.rate * fhat.test)
    
  }
  return(list("predictions.train" = predictions.train, "predictions.test" = predictions.test))
}

tree.VsMSE <- function(train.data, test.data, label.name, learn.rate) {
  
  trees <- c(100, 500, 800, 1000, 1500, 2000, 2500, 3000, 3500, 4000)
  test.MSE <- rep(0, length(trees))
  train.MSE <- rep(0, length(trees))
  
  for (j in 1:length(trees)) {

    p <- boost.dStump(train.data, test.data, label.name, learn.rate, trees[j])
    
    test.MSE[j] <- sum((test.data[, label.name] - p$predictions.test)^2)/nrow(test.data)
    train.MSE[j] <- sum((train.data[, label.name] - p$predictions.train)^2)/nrow(train.data)
    
  }
  
  plot(trees, test.MSE, col = "red", typ = 'b', xlab = "Number of Trees", ylab = "Error", ylim = c(0, 120))
  lines(trees, train.MSE, col = "blue", typ = 'b')
  legend("topright", legend = c("test MSE", "train MSE"), col = c("red", "black"), lty = 1, cex = 0.5)
  
}


tree.VsMSE(train, test, "medv", 0.01)




