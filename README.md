# MLFromScratch
This repository contains a few Machine Learning algorithms that I have coded from scratch.
I have not used any existing libraries available in R.
All algorithms are fairly basic and have been built from first principles.

1) NN.R and NNFunctions.R contains source code for K nearest neighbour implementation.

2) RegressionNN.R contains source code for a Back Prop based Neural Network. It uses the Auto dataset to predict mpg values using horsepower, weight, year and origin as predictor variables.

3) NN.xlsx is an excel sheet which can be used to test a Neural Net implementation. The implementation has input layer with 2 nodes, hidden layer with 2 nodes and ouput layer with 4 nodes. To test just enter the values of X, Y, W1(weights between i/p and hidden layer) and W2(weights between hidden and o/p layer). Activation function used is sigmoid and the network uses 2 training examples. Feed the 1st training example in cells A2,B2,C2 2nd training example in cells A3,B3,C3 and third in cells A4,B4,C4. The labels go in E2 to H4.
