function [ class, posterior ] = evaluateFern( testList, histograms, testPatch )
%EVALUATEFERN Summary of this function goes here
%   Detailed explanation goes here

numTests=size(testList(:,1));

%create binary number
binNumber=1;
for k=1:numTests
    if testPatch(testList(k,2),testList(k,1)) ...
            <= testPatch(testList(k,4),testList(k,3))
        %adjust binary number
        binNumber=binNumber+2^(k-1);
    end
end

%prepare posterior
sHisto = size(histograms);
numClasses = sHisto(1);
posterior = zeros(numClasses,1);

%normalize distribution
sumClassProbability = sum(histograms(:,binNumber));
for i=1:numClasses
    if sumClassProbability == 0
        posterior(i)= 1/numClasses;
    else
        posterior(i)= histograms(i,binNumber)/sumClassProbability;
    end
   
end
% posterior'

[~, class] = max(posterior);
% [maxValue, class] = max(posterior);
% maxValue
% class

end

