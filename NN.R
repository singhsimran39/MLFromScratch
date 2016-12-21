ptm <- proc.time()

#Source files, load the files that has all the custom built functions
source("NNFunctions.R")

#Load iris dataset
iris <- read.csv("iris.txt", header = F)
colnames(iris) <- c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width", "Species")

#Partition the iris dataset into test and train sets
train.X <- iris[1:70, -5]
test.X <- iris[71:100, -5]
train.Y <- iris[1:70, 5]
test.Y <- iris[71:100, 5]

#Load ionosphere dataset
# ion <- read.csv("ionosphere.txt", header = F)

#Partition the ionosphere dataset into test and train sets
# train.X <- ion[1:200, -35]
# test.X <- ion[201:351, -35]
# train.Y <- ion[1:200, 35]
# test.Y <- ion[201:351, 35]

#Load USPS dataset
# usps <- read.csv("USPSsubset.txt", header = F, sep = " ")
#Source tangent.R for tangent distance implementation
# source("tangent.R")

#Partition the USPS dataset into test and train sets
# train.X <- usps[1:350, -257]
# train.Y <- usps[1:350, 257]
# test.X <- usps[351:465, -257]
# test.Y <- usps[351:465, 257]

#Display some image from the data set
# par(mfrow = c(3,2))
# image(matrix(unlist(usps[10,-257]), nrow = 16, ncol = 16))
# image(matrix(unlist(usps[20,-257]), nrow = 16, ncol = 16))
# image(matrix(unlist(usps[30,-257]), nrow = 16, ncol = 16))
# image(matrix(unlist(usps[40,-257]), nrow = 16, ncol = 16))
# image(matrix(unlist(usps[50,-257]), nrow = 16, ncol = 16))
# image(matrix(unlist(usps[60,-257]), nrow = 16, ncol = 16))

#Normalize USPS dataset
# minimum <- vector(mode = 'numeric', length = nrow(usps))
# maximum <- vector(mode = 'numeric', length = nrow(usps))
# for (i in 1:nrow(usps)) {
#   minimum[i] <- min(usps[i, -257])
#   maximum[i] <- max(usps[i, -257])
# }
# 
# uspsNormalized <- (usps[, -257] - minimum) / (maximum - minimum)
# uspsNormalized <- data.frame(uspsNormalized, usps$V257)

#Partition the Normalized USPS dataset into test and train sets
# train.X <- uspsNormalized[1:350, -257]
# train.Y <- uspsNormalized[1:350, 257]
# test.X <- uspsNormalized[351:465, -257]
# test.Y <- uspsNormalized[351:465, 257]

#Call function predictLabels() to create a vector of predictions
modeledLabels <- predictLabels(test.X, train.X, train.Y, 2, "euclidean")

#Call function calculateAccuracy to calculate the percentage of correct predictions
accuracyOnTestSet <- calculateAccuracy(test.Y, modeledLabels)
print(accuracyOnTestSet)

t <- proc.time() - ptm


