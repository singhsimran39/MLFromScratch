#This function finds the smallest value and the index of the smallest value in a vector
#Arguments taken - vector 
#Values returned - a list which has the smallest value and the index of the smallest value
smallestInVector <- function(vector) {
  smallest <- vector[1]
  index <- 1
  for (i in 1:length(vector)) {
    if (vector[i] < smallest) {
      smallest <- vector[i]
      index <- i
    }
  }
  return(list("minValue" = smallest, "index" = index))
}

#This function finds the highest value and the index of the highest value in a vector
#Arguments taken - vector 
#Values returned - a list which has the highest value and the index of the highest value
highestInVector <- function(vector) {
  highest <- vector[1]
  index <- 1
  for (i in 1:length(vector)) {
    if (vector[i] > highest) {
      highest <- vector[i]
      index <- i
    }
  }
  return(list("maxValue" = highest, "index" = index))
}

#This function calculates the covariance matrix of a given matrix (common for all classes)
#Arguments taken - a matrix
#Values returned - covariance matrix 
covariance.common <- function(matrix, train.labels, class.means) {
  covariance <- matrix(data = 0, nrow = ncol(matrix), ncol = ncol(matrix))
  
  for (i in 1:nlevels(train.labels)) {
    temp <- apply(matrix[train.labels == levels(train.labels)[i], ], 1, '-', class.means[i, ])
    temp <- temp %*% t(temp)
    covariance <- covariance + temp
  }
  return(covariance)
}

#This function calculates the covariance matrix of a given matrix (different for each class)
#Arguments taken - a matrix, mean values
#Values returned - covariance matrix 
covariance.perClass <- function(mat, class.means) {
  covariance <- matrix(data = 0, nrow = ncol(mat), ncol = ncol(mat))
  
  temp <- apply(mat, 1, '-', class.means)
  temp <- temp %*% t(temp)
  covariance <- temp
}

#This function calculates the covariance for a given vector
#Arguments taken - vector, mean of the vector
#Values returned - covariance
covariance.pOne <- function(vector, class.means) {
  temp <- vector - class.means
  temp <- temp^2
  sum <- 0
  for (i in 1:length(vector)) {
    sum <- sum + temp[i]
  }
  
  covariance <- sum
  return(covariance)
}

#This function finds the best attributes based on the highest value of mean differences divided by
#standard deviation for each attribute
#Arguments taken - data set without the labels, labels of the dataset
#Values returned - index of the best attributes
attributeSelection <- function(data.attributes, data.labels, number.ofBestAttributes) {
  number.ofLabels <- nlevels(data.labels)
  actual.labels <- levels(data.labels)
  mean.labels <- matrix(data = NA, nrow = number.ofLabels, ncol = ncol(data.attributes))
  compare <- vector(mode = "numeric", length = ncol(data.attributes))
  index.ofBestAttributes <- vector(mode = "numeric", length = number.ofBestAttributes)
  
  std <- apply(data.attributes, 2, sd)
  
  for (i in 1:number.ofLabels) {
    mean.labels[i, ] <- apply(data.attributes[data.labels == actual.labels[i], ], 2, mean)
  }
  compare <- abs(mean.labels[1, ] - mean.labels[2, ])/std

  if (number.ofBestAttributes > 1 && number.ofBestAttributes != ncol(data.attributes)) {
    for (i in 1:number.ofBestAttributes) {
      highest.index <- highestInVector(compare)$index
      index.ofBestAttributes[i] <- highest.index
      compare[highest.index] <- smallestInVector(compare)$minValue
    }
  } else if (number.ofBestAttributes == ncol(data.attributes)) {
    index.ofBestAttributes <- 1:ncol(data.attributes)
  } else {
    index.ofBestAttributes <- highestInVector(compare)$index
  }
  
  return(index.ofBestAttributes)
}

#USing LDA this function predicts the labels for given test data when number of attributes is one
#Arguments taken - index of the most informative attribute, training attributes, train labels, test labels
#Values returned - vector of predicted labels
linearDA.pOne <- function(index.ofInformativeAttributes, train.attributes, train.labels, test.attributes) {
  
  class.wiseMean <- vector(mode = "numeric", length = nlevels(train.labels))
  class.wiseSigmaSq <- vector(mode = "numeric", length = nlevels(train.labels))
  prior.probability <- vector(mode = "numeric", length = nlevels(train.labels))
  predicted.labels <- vector(mode = "numeric", length = nrow(test.attributes))
  
  for (i in 1:nlevels(train.labels)) {
    class.wiseMean[i] <- mean(train.attributes[train.labels == levels(train.labels)[i], 
                                               index.ofInformativeAttributes])
    
    class.wiseSigmaSq[i] <- sum((train.attributes[train.labels == levels(train.labels)[i], 
                                                  index.ofInformativeAttributes] - class.wiseMean[i])^2)
    
    prior.probability[i] <- length(train.attributes[train.labels == levels(train.labels)[i], 
                                                    index.ofInformativeAttributes])/nrow(train.attributes)
  }
  
  sigma.sq <- sum(class.wiseSigmaSq)/(nrow(train.attributes) - nlevels(train.labels))
  coeff.ofX <- class.wiseMean/sigma.sq
  
  repeat.matrix <- matrix(rep(coeff.ofX, nrow(test.attributes)), nrow = nrow(test.attributes), byrow = T)
  term1 <- test.attributes[, index.ofInformativeAttributes] * repeat.matrix
  
  term2 <- (class.wiseMean^2)/(2 * sigma.sq)
  term2 <- matrix(rep(term2, nrow(test.attributes)), nrow = nrow(test.attributes), byrow = T)
  
  term3 <- log(prior.probability)
  term3 <- matrix(rep(term3, nrow(test.attributes)), nrow = nrow(test.attributes), byrow = T)
  
  class.wiseDelta <- term1 - term2 + term3
  
  for (i in 1:nrow(class.wiseDelta)) {
    index.OfMaxValue <- highestInVector(class.wiseDelta[i, ])$index
    predicted.labels[i] <- levels(train.labels)[index.OfMaxValue]
  }
  return(predicted.labels)
}

#Using LDA this function predicts the labels for given test data when number of attributes is more than one
#Arguments taken - index of the most informative attributes, training attributes, train labels, test labels
#Values returned - vector of predicted labels
linearDA.pGeneral <- function(index.ofInformativeAttributes, train.attributes, train.labels, test.attributes) {
  
  train.attributes <- as.matrix(train.attributes)
  test.attributes <- as.matrix(test.attributes)

  #Matrix of means. First row has mean for all attributes for first class and so on.
  class.wiseMean <- matrix(data = NA, nrow = nlevels(train.labels), ncol = length(index.ofInformativeAttributes))
  class.wiseDelta <- matrix(data = NA, nrow = nrow(test.attributes), ncol = nlevels(train.labels))
  prior.probability <- vector(mode = "numeric", length = nlevels(train.labels))
  predicted.labels <- vector(mode = "numeric", length = nrow(test.attributes))
  
  for (i in 1:nlevels(train.labels)) {
    class.wiseMean[i, ] <- colMeans(train.attributes[train.labels == levels(train.labels)[i],
                                                     index.ofInformativeAttributes])
    
    prior.probability[i] <- length(train.attributes[train.labels == levels(train.labels)[i],
                                                    index.ofInformativeAttributes])/nrow(train.attributes)
  }
  
  covariance <- covariance.common(train.attributes[, index.ofInformativeAttributes], 
                                  train.labels, class.wiseMean)
  covariance <- covariance/(nrow(train.attributes) - nlevels(train.labels))
  
  for (i in 1:nrow(class.wiseMean)) {
    term1 <- test.attributes[, index.ofInformativeAttributes] %*% solve(covariance) %*%
      matrix(class.wiseMean[i, ])
    
    term2 <- (t(matrix(class.wiseMean[i, ])) %*% solve(covariance) %*% matrix(class.wiseMean[i, ]))/2
    term2 <- matrix(rep(term2, nrow(test.attributes)), nrow = nrow(test.attributes), byrow = T)
    
    term3 <- log(prior.probability[i])
    term3 <- matrix(rep(term3, nrow(test.attributes)), nrow = nrow(test.attributes), byrow = T)
    
    class.wiseDelta[, i] <- term1 - term2 + term3
  }
  
  for (i in 1:nrow(class.wiseDelta)) {
    index.ofMaxValue <- highestInVector(class.wiseDelta[i, ])$index
    predicted.labels[i] <- levels(train.labels)[index.ofMaxValue]
  }
  return(predicted.labels)
}

#Using QDA this function predicts the labels for given test data when number of attributes is one
#Arguments taken - index of the most informative attributes, training attributes, train labels, test labels
#Values returned - vector of predicted labels
quadraticDA.pOne <- function(index.ofInformativeAttributes, train.attributes, train.labels, test.attributes) {
  
  class.wiseMean <- vector(mode = "numeric", length = nlevels(train.labels))
  class.wiseDelta <- matrix(data = NA, nrow = nrow(test.attributes), ncol = nlevels(train.labels))
  prior.probability <- vector(mode = "numeric", length = nlevels(train.labels))
  predicted.labels <- vector(mode = "numeric", length = nrow(test.attributes))
  
  for (i in 1:nlevels(train.labels)) {
    class.wiseMean[i] <- mean(train.attributes[train.labels == levels(train.labels)[i], 
                                               index.ofInformativeAttributes])
    prior.probability[i] <- length(train.attributes[train.labels == levels(train.labels)[i], 
                                                    index.ofInformativeAttributes])/nrow(train.attributes)
  }
  
  for (i in 1:nlevels(train.labels)) {
    
    covariance <- covariance.pOne(train.attributes[train.labels == levels(train.labels)[i], 
                                                   index.ofInformativeAttributes], 
                                  class.wiseMean[i])
    covariance <- covariance/(length(train.attributes[train.labels == levels(train.labels)[i], 
                                                      index.ofInformativeAttributes]) - 1)
    
    term1 <- (-1/2) * (test.attributes[, index.ofInformativeAttributes]^2)/covariance
    
    term2 <- (test.attributes[, index.ofInformativeAttributes] * class.wiseMean[i])/covariance
    
    term3 <- (-1/2) * (class.wiseMean[i]^2)/covariance
    term3 <- rep(term3, nrow(test.attributes))
    
    term4 <- (-1/2) * log(det(as.matrix(covariance)))
    term4 <- rep(term4, nrow(test.attributes))
    
    term5 <- log(prior.probability[i])
    term5 <- rep(term5, nrow(test.attributes))
    
    class.wiseDelta[, i] <- term1 + term2 + term3 + term4 + term5
  }
  
  for (i in 1:nrow(class.wiseDelta)) {
    index.ofMaxValue <- highestInVector(class.wiseDelta[i, ])$index
    predicted.labels[i] <- levels(train.labels)[index.ofMaxValue]
  }
  return(predicted.labels)
}

#Using QDA this function predicts the labels for given test data when number of attributes is more than one
#Arguments taken - index of the most informative attributes, training attributes, train labels, test labels
#Values returned - vector of predicted labels
quadraticDA.pGeneral <- function(index.ofInformativeAttributes, train.attributes, train.labels, test.attributes) {
  
  train.attributes <- as.matrix(train.attributes)
  
  class.wiseMean <- matrix(data = NA, nrow = nlevels(train.labels), ncol = length(index.ofInformativeAttributes))
  class.wiseDelta <- matrix(data = NA, nrow = nrow(test.attributes), ncol = nlevels(train.labels))
  prior.probability <- vector(mode = "numeric", length = nlevels(train.labels))
  predicted.labels <- vector(mode = "numeric", length = nrow(test.attributes))
  
  for (i in 1:nlevels(train.labels)) {
    
    class.wiseMean[i, ] <- colMeans(train.attributes[train.labels == levels(train.labels)[i], 
                                                     index.ofInformativeAttributes])
    
    prior.probability[i] <- length(train.labels[train.labels == levels(train.labels)[i]])/length(train.labels)
  }
  
  for (i in 1:nrow(class.wiseMean)) {
    covariance <- covariance.perClass(train.attributes[train.labels == levels(train.labels)[i], 
                                                       index.ofInformativeAttributes], 
                                      class.wiseMean[i, ])
    covariance <- covariance/(nrow(train.attributes[train.labels == levels(train.labels)[i], ]) - 1)
    
    for (j in 1:nrow(test.attributes)) {
      term1 <- t(t(as.matrix(test.attributes[j, index.ofInformativeAttributes])) - as.matrix(class.wiseMean[i, ])) %*% 
        solve(covariance, tol = 1e-19) %*% 
        t(as.matrix(test.attributes[j, index.ofInformativeAttributes]) - class.wiseMean[i, ])
      term1 <- (-1/2) * term1
      
      term2 <- (-1/2) * log(det(covariance))
      
      term3 <- log(prior.probability[i])
      
      class.wiseDelta[j, i] <- term1 + term2 + term3
    }
    
  }
  for (i in 1:nrow(class.wiseDelta)) {
    index.ofMaxValue <- highestInVector(class.wiseDelta[i, ])$index
    predicted.labels[i] <- levels(train.labels)[index.ofMaxValue]
  }
  return(predicted.labels)
}

#This function calculates the accuracy of the predictions made using predictLabels function
#Arguments taken - test labels, predicted labels
#Value returned - accuracy of predictions
calculateAccuracy <- function(testLabels, predictedLabels) {
  correctPredictions <- 0
  for (i in 1:length(testLabels)) {
    if (testLabels[i] == predictedLabels[i]) {
      correctPredictions <- correctPredictions + 1
    }
  }
  accuracy <- (correctPredictions / length(testLabels)) * 100
  return(accuracy)
}
