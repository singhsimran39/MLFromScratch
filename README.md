# Machine Learning Algorithms from scratch

This repository contains a few Machine Learning algorithms that I have coded from scratch.
All have been built from first principles.

### K Means Clustering using MapReduce
 - The [K-means](https://github.com/singhsimran39/MLFromScratch/tree/master/KMeans2) algorithm involves randomly selecting K initial centroids where K is a user defined number of desired clusters. This iterative process has been built using the MapReduce framework. 

### Clustering

  - [hclust_Single.R](https://github.com/singhsimran39/MLFromScratch/blob/master/Clustering/hclust_Single.R) - Heirarchical agglomerative clustering using single linakge.

### Discriminant Analysis
 - Discriminant Analysis methods approximate Bayes Classifier by using the estimates of Prior Probability, Class Mean and Class Standard Deviation.
 - The [directory](https://github.com/singhsimran39/MLFromScratch/tree/master/DiscriminantAnalysis) contains code for both Linear and Quadratic Discriminant Analysis and the helper methods.

### Ensemble Methods
- [This repository](https://github.com/singhsimran39/MLFromScratch/tree/master/EnsembleMethods) Contains implemetation of boosted decision stumps.

### KNN
- [K Nearest Neighbour](https://github.com/singhsimran39/MLFromScratch/tree/master/KNN) Implementation generalized for different values of K. 

### Neural Nets
-  [NN.xlsx](https://github.com/singhsimran39/MLFromScratch/blob/master/NeuralNetworks/NN.xlsx) - is an excel sheet which can be used to test a Neural Net implementation. The implementation has input layer with 2 nodes, hidden layer with 2 nodes and ouput layer with 4 nodes. To test just enter the values of X, Y, W1(weights between i/p and hidden layer) and W2(weights between hidden and o/p layer). Activation function used is sigmoid and the network uses 3 training examples.
-  [NN_Regression.R](https://github.com/singhsimran39/MLFromScratch/blob/master/NeuralNetworks/NN_Regression.R) - Neural Network that learns on Back Propagation. The network uses horsepower, weight, year and origin predictors to predict the mpg value for the Auto dataset in R.
-  [neuralTrain_MNIST.m](https://github.com/singhsimran39/MLFromScratch/blob/master/NeuralNetworks/MNIST.m) - Classification Neural Network with 784 input units, 1 hidden layer and 10 output units. This is implemented on the MNIST dataset.