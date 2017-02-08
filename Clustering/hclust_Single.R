nci <- read.csv("nci.data.txt", sep = "", header = F)
nci <- as.matrix(nci)

#nci <- nci[ , 1:13] FOr testing purposes

diff.matrix <- function(dataMat) {
  
  diffMat <- matrix(Inf, nrow = ncol(nci), ncol = ncol(nci))
  
  for(i in 1:ncol(nci)) {
    repMat <- matrix(rep(nci[, i], ncol(nci)), nrow = nrow(nci), ncol = ncol(nci))
    temp <- colSums((repMat - nci)^2)
    diffMat[i, ] <- sqrt(temp)
  }
  diag(diffMat) <- Inf
  
  return(diffMat)
  
}

hclust.single <- function(diffMat, dataMat) {
  
  fuse <- matrix(NA, ncol = 3, nrow = ncol(dataMat) - 1)
  tempMat <- matrix(NA, ncol = ncol(dataMat), nrow = ncol(dataMat))
  clustCount <- 0
  
  for(i in 1:nrow(fuse)) {
    
    mins <- which(diffMat == min(diffMat), arr.ind = T)[1, ]
    
    common <- intersect(tempMat, mins)
    notCommon <- setdiff(mins, tempMat)
    
    if(sum(common) == 0) {
      
      clustCount <- clustCount + 1
      fuse[i, ] <- c(-mins[1], -mins[2], clustCount)
      a <- which(NA %in% tempMat[i, ])
      tempMat[i, a:(a+1)] <- c(mins[1], mins[2])
      
      diffMat[mins[1], mins[2]] <- Inf
      diffMat[mins[2], mins[1]] <- Inf
      
    } else {
      
      clustCount <- clustCount + 1
      
      if(length(common) > 1) {
        
        ind1 <- which(fuse[, 1:2] == -common[1], arr.ind = T)[, 1]
        ind2 <- which(fuse[, 1:2] == -common[2], arr.ind = T)[, 1]
        prevCluster <- fuse[c(ind1, ind2), 3]
        
        fuse[, 3] <- ifelse(fuse[,3] == prevCluster[1], clustCount, fuse[, 3])
        fuse[, 3] <- ifelse(fuse[,3] == prevCluster[2], clustCount, fuse[, 3])
        
        fuse[i, ] <- c(prevCluster[1], prevCluster[2], clustCount)
        
        r1 <- which(tempMat == common[1], arr.ind = T)[, 1]
        r2 <- which(tempMat == common[2], arr.ind = T)[, 1]
        r <- c(r1, r2)
        
      } else {
        
        ind1 <- which(fuse[, 1:2] == -common, arr.ind = T)[, 1]
        prevCluster <- fuse[ind1, 3]
        
        fuse[, 3] <- ifelse(fuse[, 3] == prevCluster, clustCount, fuse[, 3])
        fuse[i, ] <- c(-notCommon, prevCluster, clustCount)
        
        r <- which(tempMat == common, arr.ind = T)[, 1]
        
      }
      
      newCluster <- na.omit(unique(c(mins, tempMat[r, ])))
      m <- combn(newCluster, 2)
      for(j in 1:ncol(m)) {
        diffMat[m[,j][1], m[,j][2]] <- Inf
        diffMat[m[,j][2], m[,j][1]] <- Inf
      }
      
      tempMat[i, 1:length(newCluster)] <- newCluster
    }
  }
  fuse <- fuse[, 1:2]
  
  return(fuse)
  
}


diffMat <- diff.matrix(nci)

clusters <- hclust.single(diffMat, nci)