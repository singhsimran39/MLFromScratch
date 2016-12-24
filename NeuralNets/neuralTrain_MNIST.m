% function [W1, W2] = neuralTrain(trainAtr, trainLbl, hL, epochs, lRate)
    clear;
    trainAtr = loadMNISTImages('train-images.idx3-ubyte');
    trainLbl = loadMNISTLabels('train-labels.idx1-ubyte');
    X = trainAtr';
    Y = trainLbl;
    X = X(1:45000, :);
    Y = Y(1:45000, :);
    lambda = 0.5;
    
    nX = (X - mean(X));
    eyeMat = eye(10);
    Y(Y == 0) = 10;
    mY = eyeMat(Y, :);
    hL = 60; lRate = .005; oL = size(mY, 2);
   
    %nX = cos([1 2 ; 3 4 ; 5 6]); hL = 2; oL = 4; Y = [4; 2; 3]; lRate = .01;
    %eyeMat = eye(4);
    %mY = eyeMat(Y, :);

    [r, c] = size(nX);

    %W1 = 1.4 * rand(hL, (c+1)) - 0.7;
    W1 = rand(hL, (c+1));
    %W1 = [.1 .3 .5; .2 .4 .6];
    [rW1, cW1] = size(W1);    
    
    %W2 = 1.4 * rand(oL, (hL+1)) - 0.7;
    W2 = rand(oL, (hL+1));
    %W2 = [.7 1.1 1.5; .8 1.2 1.6; .9 1.3 1.7; 1 1.4 1.8];
    [rW2, cW2] = size(W2);    

    %Add bias unit and make bias as the first column of the matrix
    nX = [ones(r, 1) nX];
    %totalMSE = zeros(500, 1);
    
    for j = 1:100
                       
         dW1 = zeros(rW1, cW1);
         dW2 = zeros(rW2, cW2);
         online = 0;
         
         for i = 1:r
             online = online + 1;
             %Forward Pass
             a1 = nX(i, :);
             z2 = a1 * W1';
             a2 = sig(z2);

             a2 = [1 a2];            %Add bias to hidden layer
             z3 = a2 * W2';
             a3 = sig(z3);
             Yhat = a3;
            
             %Backward Pass
             temp = sigPrime(z3);
             delta3 = -1 .* (mY(i, :) - Yhat) .* temp;
             dW2 = dW2 + (delta3' * a2);
            
             temp = sigPrime(z2) .* W2(:, 2:end);
             delta2 = temp' * delta3'; 
             dW1 = dW1 + (delta2 * a1); 
             
             if (online == 10)
                 W1 = W1 + (lRate/r) .* dW1;
                 W2 = W2 + (lRate/r) .* dW2;
                 dW1 = zeros(rW1, cW1);
                 dW2 = zeros(rW2, cW2);
                 online = 0;
             end             
         end            
    end
             
    
    %Test Predictions
%     testAtr = loadMNISTImages('t10k-images.idx3-ubyte');
%     testLbl = loadMNISTLabels('t10k-labels.idx1-ubyte');
%     xT = testAtr'; xT = xT(1:100, :);
%     yT = testLbl; yT = yT(1:100, :);
%     xT = [ones(size(xT, 1), 1) xT];
% 
%     a1 = xT;
%     z2 = a1 * W1';
%     a2 = sig(z2);
% 
%     a2 = [ones(size(a2, 1), 1) a2];            %Add bias to hidden layer
%     z3 = a2 * W2';
%     a3 = sig(z3);
%     YPred = a3;
%     [~, final] = max(YPred, [], 2);

%     Train Predictions
      X = trainAtr';
      a1 = X(45001:end,:);
      a1 = [ones(size(a1, 1), 1) a1];
      z2 = a1 * W1';
      a2 = sig(z2);
     
      a2 = [ones(size(a2, 1), 1) a2];
      z3 = a2 * W2';
      a3 = sig(z3);
     
      YPred = a3;
      [~, final] = max(YPred, [], 2);
            
%end







