function [ H, bestSample ] = adaptive_ransac( S, s, tt )
%RANDAC Summary of this function goes here
%   Detailed explanation goes here
%
%
% Objective
%  Robust ?t of a model to a data set S which contains outliers.
% Algorithm
%  (i)   Randomly select a sample of s data points from S and instantiate the model from this subset.
%  (ii)  Determine the set of data points Si which are within a distance threshold t of the model.
%        The set Si is the consensus set of the sample and de?nes the inliers of S.
%  (iii) If the size of Si (the number of inliers) is greater than some threshold T,
%        re-estimate the model using all the points in Si and terminate.
%  (iv)  If the size of Si is less than T, select a new subset and repeat the above.
%  (v)   After N trials the largest consensus set Si is selected, and the model is
%        re-estimated using all the points in the subset Si.
%
%
% Threshold t^2=5.99*sigma^2 (if data points are gaussian distributed).
% This will guarantee inliers to be rejected incorrectly with a probability of 5%.
%
% How many samples s?
% Sample size | Proportion of outliers <epsilon>
%      s      | 5% 10% 20% 25% 30% 40%  50%
% -----------------------------------------
%      2      | 2   3   5   6   7  11   17
%      3      | 3   4   7   9  11  19   35
%      4      | 3   5   9  13  17  34   72
%      5      | 4   6  12  17  26  57  146
%      6      | 4   7  16  24  37  97  293
%      7      | 4   8  20  33  54 163  588
%      8      | 5   9  26  44  78 272 1177
%
% When to terminate? -> How to choose T?
% T = (1 ? <epsilon>)n
%
%
% Unknown <epsilon>!? -> Adaptively recalculate N (and therefore,
% <epsilon>:
% ? N = oo , sample count= 0.
% ? While N > sample count Repeat
%    ? Choose a sample and count the number of inliers.
%    ? Set <epsilon> = 1 - (number_of_inliers)/(total_number_of_points)
%    ? Set N from <epsilon> and N = log(1 - p)/ log(1 - (1 - <epsilon>)^s) with p = 0.99.
%    ? Increment the sample count by 1.
% ? Terminate.
%
% N_0 = oo <=> <epsilon>_0 = 1.0

dataLength = size(S,2);

N = Inf;
Si = [];
sampleCount = 0;
epsilon = 1.0;
p = 0.99;
while N > sampleCount
    N
    %%%%%%%%%%%%%%%%%%%? Choose a sample and count the number of inliers.
    
    %  (i)   Randomly select a sample of s data points from S and instantiate
    %        the model from this subset.
    randomVector = randperm(dataLength);
    sampleIndices = randomVector(1:s);
    currSample = S(:,sampleIndices);
    display('currSample')
    currSample
    currH = dlt(currSample(1:2,:), currSample(3:4,:));
    
    
    %  (ii)  Determine the set of data points Si which are within a distance
    %        threshold t of the model. The set Si is the consensus set of the
    %        sample and defines the inliers of S.
    fp1 = padarray(S(1:2,:),1,1,'post');
    fp2 = padarray(S(3:4,:),1,1,'post');
    
    % fp1     = hnormalise(fp1);
    % fp2     = hnormalise(fp2);
    % Hfp1    = hnormalise(currH*fp1);
    % invHfp2 = hnormalise(inv(currH)*fp2);
    fp1 = hnormalise(fp1);
    fp2 = hnormalise(fp2);
    display('currH')
    currH
    display('InvH')
    invH = inv(currH)
    
    currH = currH / min(min(abs(currH(currH>0))));
    Hfp1 = hnormalise(currH*fp1);
    invH = invH / min(min(abs(invH(invH>0))));
    invHfp2 = hnormalise(invH*fp2);
    
    dd = sum((fp1-invHfp2).^2)  + sum((fp2-Hfp1).^2)
    currSi = S(:,(abs(dd) < tt))
    
    %  (iii) If the size of Si (the number of inliers) is greater than some
    %        threshold T, re-estimate the model using all the points in Si
    %        and terminate.
    currSizeSi = size(currSi,2);
%     if currSizeSi > sizeSi
%         Si = currSi;
%         sizeSi = currSizeSi;
%     end
    
    %%%%%%%%%%%%%%%%%%%? Set <epsilon> = 1 - (number_of_inliers)/(total_number_of_points)
    currEpsilon = 1 - currSizeSi / dataLength;
    
    if currEpsilon < epsilon
        Si = currSi;
        epsilon = currEpsilon;
        
        %%%%%%%%%%%%%%%%%%%? Set N from <epsilon> and N = log(1 - p)/ log(1 - (1 - <epsilon>)^s) with p = 0.99.
        N = log(1 - p) / log(1 - (1-currEpsilon)^s);
    end
    
    %%%%%%%%%%%%%%%%%%%? Increment the sample count by 1.
    sampleCount = sampleCount + 1;
    
end
bestSample = Si
H = dlt(bestSample(1:2,:), bestSample(3:4,:));

end

