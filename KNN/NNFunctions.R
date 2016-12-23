#This function finds the Sum of square of rows of a data frame.
#Arguments taken - data frame
#Value returned - sum of squares 
sumOfRows <- function(data_frame){
  sum <- numeric(nrow(data_frame))
  data_frame <- data_frame^2
  
  for (i in 1:nrow(data_frame)) {
    for (j in 1:ncol(data_frame)) {
      sum[i] <- sum[i] + data_frame[i, j]
    }
  }
  return(sum)
}

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

#This function sorts a vector and then finds the mode of the vector
#Arguments taken - vector
#Values returned - mode of the vector
sortAndMode <- function(vector) {
  #Sort the vector
  for (i in 1:length(vector)) {
    for (j in 1:(length(vector) - 1)) {
      if (vector[j] > vector[j + 1]) {
        temp <- vector[j]
        vector[j] <- vector[j + 1]
        vector[j + 1] <- temp
      }
    }
  }
  #Find the mode of the sorted vector
  mode <- vector[1]
  occurance <- 1
  totalOccurance <- 1
  
  for (counter in 1:(length(vector) - 1)) {
    if (vector[counter] == vector[counter + 1]) {
      occurance <- occurance + 1
      if (totalOccurance < occurance) {
        totalOccurance <- occurance
        mode <- vector[counter]
      }
    }
    else {
      occurance <- 1
    }
  }
  return(mode)
}

#This function predicts the labels of the test set
#Arguments taken - test attributes, training attributes, training labels, value of k and metrics to be used
#for prediction i.e. euclidean or tangent
#Values returned - vector of predicted labels
predictLabels <- function(test.attributes, train.attributes, train.labels, k = 1, metric) {
  
  predictedLabel <- vector(mode = "numeric", length = nrow(test.attributes))
  
  if (metric == "tangent") {
    tangentDistance <- vector(mode = 'numeric', length = nrow(train.attributes))
    
    for (i in 1:nrow(test.attributes)) {           #For each test example
      for (j in 1:nrow(train.attributes)) {        #Calculate the distance from each train example
        tangentDistance[j] <- distance(test.attributes[i, ], train.attributes[j, ])
      }
      
      #Get the label of the nearest neighbour for different values of K
      predictedLabel[i] <- forDifferentK(k, tangentDistance, train.labels)
    }
  }
  
  else if (metric == "euclidean") {
    differenceDataFrame <- data.frame(matrix(ncol = ncol(train.attributes), nrow = nrow(train.attributes)))
    euclideanDistance <-  vector(mode = "numeric", length = nrow(train.attributes))
    
    for (i in 1:nrow(test.attributes)) {            #for each test example
      #Repeat the first row of the test matrix 
      repeatMatrix <- matrix(unlist(rep(test.attributes[i, ], nrow(train.attributes))),
                             nrow = nrow(train.attributes), ncol = ncol(train.attributes),
                             byrow = TRUE)
      
      #Subtract it from the train matrix
      differenceMatrix <- repeatMatrix - train.attributes
      #Find the norm of the difference matrix
      euclideanDistance <- sqrt(sumOfRows(differenceMatrix))

      #Get the label of the nearest neighbour for different values of K
      predictedLabel[i] <- forDifferentK(k, euclideanDistance, train.labels)
    }
  }
  return(predictedLabel)
}

#Helper function that calculates the label of the nearest neighbours
#Arguments taken - value of K, a vector with the distances, train labels
#Values returned - label of the nearest neighbour
forDifferentK <- function(k, distanceVector, train.labels) {
  label <- 0
  if (k == 1) {
    label <- train.labels[smallestInVector(distanceVector)$index]
  }
  else {
    indexWithHighestValue <- highestInVector(distanceVector)$index
    vote <- vector(mode = "numeric", length = k)
    
    for (counter in 1:k) {
      indexWithSmallestValue <- smallestInVector(distanceVector)$index   #index for the smallest distance
      
      vote[counter] <- train.labels[indexWithSmallestValue]                      #put the label for vote
      distanceVector[indexWithSmallestValue] <- distanceVector[indexWithHighestValue]
    }
    label <- sortAndMode(vote)                #Find the label that occurs the most number of times in vote
  }
  return(label)
}

#This function calculates the accuracy of the predictions made using predictLabels function
#Arguments taken - test labels, predicted labels
#Value returned - accuracy of predictions
calculateAccuracy <- function(testLabels, modeledLabels) {
  correctPredictions <- 0
  for (i in 1:length(testLabels)) {
    if (testLabels[i] == modeledLabels[i]) {
      correctPredictions <- correctPredictions + 1
    }
  }
  accuracy <- (correctPredictions / length(testLabels)) * 100
  return(accuracy)
}
