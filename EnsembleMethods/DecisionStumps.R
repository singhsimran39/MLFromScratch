library(MASS)
source("BDS_Functions.R")

boston <- Boston[, c("medv", "lstat", "rm")]
attach(boston)

set.seed(0319)
randomNumbers <- sample(1:nrow(boston), nrow(boston)/2)
train <- boston[randomNumbers, ]
test <- boston[-randomNumbers, ]

#Call the decision stump implementation function
best.values <- d.stump(train, "medv")

#This function calculates test predictions and test MSE for the decision stump
test.calculations <- function(test.data, label.name, optimal) {

  predictions <- ifelse(test.data[, optimal$feature] < optimal$split, optimal$meanlT, optimal$meangT)
  MSE <- sum((predictions - test[, label.name])^2)/nrow(test.data)

}

#Call the function to calculate the test MSE for the decision stump
t.MSE <- test.calculations(test, "medv", best.values)

