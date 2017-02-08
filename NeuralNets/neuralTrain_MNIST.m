    clear;
    %trainAtr = loadMNISTImages('train-images-idx3-ubyte');
    %trainLbl = loadMNISTLabels('train-labels-idx1-ubyte');
    %trainAtr = trainAtr';
    %X = trainAtr(1:50000, :);
    %Y = trainLbl(1:50000, :);
    
    data = csvread('train.csv', 1, 0);
    X = data(1:32000, 2:end);
    Y = data(1:32000, 1);
    
    mu = mean(X);
    sigma = std(X);
    sigma(sigma == 0) = 1;
    nX = (X - mu) ./ sigma;
    eyeMat = eye(10);
    Y(Y == 0) = 10;
    mY = eyeMat(Y, :);
    hL = 90; lRate = .05; oL = size(mY, 2);
    
%     nX = cos([1 2 ; 3 4 ; 5 6]); Y = [4; 2; 3]; hL = 2;
%     eyeMat = eye(4);
%     Y(Y == 0) = 4;
%     mY = eyeMat(Y, :);
%     
%     W1 = [.1 .3 .5;.2 .4 .6];
%     W2 = [.7 1.1 1.5;.8 1.2 1.6;.9 1.3 1.7;1 1.4 1.8];
    [r, c] = size(nX);

    W1 = rand(hL, (c+1));
    [rW1, cW1] = size(W1);    
    
    W2 = rand(oL, (hL+1));
    [rW2, cW2] = size(W2);    

    %Add bias unit and make bias as the first column of the matrix
    nX = [ones(r, 1) nX];
    dW1 = zeros(rW1, cW1);
    dW2 = zeros(rW2, cW2);
        
    for j = 1:100
         
         for i = 1:r
             
             %Forward Pass
             a1 = nX(i, :);
             z2 = a1 * W1';
             a2 = sig(z2, 'hyperbolic');

             a2 = [1 a2];            %Add bias to hidden layer
             z3 = a2 * W2';
             a3 = sig(z3, 'hyperbolic');
             Yhat = a3;
            
             %Backward Pass
             delta3 = Yhat - mY(i, :);
             temp1 = delta3' * a2;
             dW2 = dW2 + temp1;
             
             temp2 = delta3 * W2(:, 2:end);
             delta2 = temp2 .* sigPrime(z2, 'hyperbolic');
             dW1 = dW1 + (delta2' * a1);
           
         end
         W1 = W1 - (lRate/r) .* dW1;
         W2 = W2 - (lRate/r) .* dW2;
    end
    
    %Predict train
%     X = [ones(r, 1) X];
%     a1 = X;
%     z2 = a1 * W1';
%     a2 = sig(z2);
%     
%     a2 = [ones(size(a2, 1), 1) a2];
%     z3 = a2 * W2';
%     a3 = sig(z3);
%     Yhat = a3;
    
    %Predict test
    xT = data(32001:end, 2:end);
    yT = data(32001:end, 1);
    xT = [ones(size(xT, 1), 1) xT];
    
    a1T = xT;
    z2T = a1T * W1';
    a2T = sig(z2T, 'hyperbolic');
    
    a2T = [ones(size(a2T, 1), 1) a2T];
    z3T = a2T * W2';
    a3T = sig(z3T, 'hyperbolic');
    [~, final] = max(a3T, [], 2);
    accuracy = sum(final == yT);
    
    
    
    
    
    

