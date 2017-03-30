source("DiscriminantAnalysis_Functions.R")

#==========================IRIS Dataset Start==========================================#
# iris <- read.csv("iris.txt", header = F)
# iris$V5 <- factor(iris$V5)
# #
# randomNumbers <- sample(1:100, 70)
# total.X <- iris[ , -5]
# total.Y <- iris[ , 5]
# train.X <- iris[randomNumbers, -5]
# train.Y <- iris[randomNumbers, 5]
# test.X <- iris[-randomNumbers, -5]
# test.Y <- iris[-randomNumbers, 5]


#========================PARKINSONS Dataset Start======================================#
park <- read.csv("parkinsons.data")
park <- park[, -1]
park$status <- as.factor(park$status)
randomNumbers <- sample(1:195, 120)
total.X <- park[ , -17]
total.Y <- park[ , 17]
train.X <- park[randomNumbers, -17]
train.Y <- park[randomNumbers, 17]
test.X <- park[-randomNumbers, -17]
test.Y <- park[-randomNumbers, 17]



#=================================IMPLEMENTATION=====================================#
#provide the full dataset and the number of attributes to make the predictions on
index.ofInformativeAttributes <- attributeSelection(total.X, total.Y, 11)

#Predict the labels
if (length(index.ofInformativeAttributes) == 1) {
  predicted.labels <- linearDA.pOne(index.ofInformativeAttributes, train.X, train.Y, test.X)
  } else {
    predicted.labels <- linearDA.pGeneral(index.ofInformativeAttributes, train.X, train.Y, test.X)
  }

#Calculate accuracy
accuracy.onTestSet <- calculateAccuracy(test.Y, predicted.labels)
print(accuracy.onTestSet)

