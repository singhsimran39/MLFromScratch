#Decision Stump Implementation
#Function takes train data and the label name as input arguments
#Returns the best feature and split value to cut at and the mean values
d.stump <- function(train.data, label.name) {
  
  features <- subset(colnames(train.data), colnames(train.data) != label.name)
  per.featureRSS <- rep(0, length(features))
  split.at <- rep(0, length(features))
  
  for (i in 1:length(features)) {
    
    name <- features[i]
    thres <- seq(round(min(train.data[, name]), 1), round(max(train.data[, name]), 1), 0.1)
    t.RSS <- rep(0, length(thres))
    train.pred <- rep(0, nrow(train.data))
    
    for (j in 1:length(thres)) {
      
      less.than <- subset(train.data, train.data[, name] < thres[j])
      greater.than <- subset(train.data, train.data[, name] > thres[j])
      
      mean.lessThan <- mean(less.than[, label.name])
      mean.greaterThan <- mean(greater.than[, label.name])
      
      train.pred <- ifelse(train.data[, name] < thres[j], mean.lessThan, mean.greaterThan)
      
      t.RSS[j] <- sum((train.pred - train.data[, label.name])^2)
      
    }
    
    per.featureRSS[i] <- min(t.RSS)
    split.at[i] <- thres[which.min(t.RSS)]
    
  }
  
  optimal.feature <- features[which.min(per.featureRSS)]
  optimal.split <- split.at[which.min(per.featureRSS)]
  
  lT <- subset(train.data, train.data[, optimal.feature] < optimal.split)
  gT <- subset(train.data, train.data[, optimal.feature] > optimal.split)
  
  mean.lT <- mean(lT[, label.name])
  mean.gT <- mean(gT[, label.name])
  
  return(list("feature" = optimal.feature, "split" = optimal.split, "meanlT" = mean.lT, "meangT" = mean.gT))
}

