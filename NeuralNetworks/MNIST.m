clear;
    trainAtr = loadMNISTImages('train-images.idx3-ubyte');
    trainLbl = loadMNISTLabels('train-labels.idx1-ubyte');
    X = trainAtr';
    Y = trainLbl;
    
    nX = (X - mean(X));
    eyeMat = eye(10);
    Y(Y == 0) = 10;
    mY = eyeMat(Y, :);
    hL = 60; lRate = .005; oL = size(mY, 2);

    [r, c] = size(nX);

    W1 = rand(hL, (c+1));
    [rW1, cW1] = size(W1);    
    
    W2 = rand(oL, (hL+1));
    [rW2, cW2] = size(W2);    

    %Add bias unit and make bias as the first column of the matrix
    nX = [ones(r, 1) nX];
        
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
    
    
    testAtr = loadMNISTImages('t10k-images-idx3-ubyte');
    testLbl = loadMNISTLabels('t10k-labels-idx1-ubyte');
    testAtr = trainAtr';
    
    xT = testAtr;
    yT = testLbl;
    xT = [ones(size(xT, 1), 1) xT];   
    a1T = xT;
    z2T = a1T * W1';
    a2T = sig(z2T, 'hyperbolic');
     
    a2T = [ones(size(a2T, 1), 1) a2T];
    z3T = a2T * W2';
    a3T = sig(z3T, 'hyperbolic');
    [~, final] = max(a3T, [], 2);
    accuracy = sum(final == yT);