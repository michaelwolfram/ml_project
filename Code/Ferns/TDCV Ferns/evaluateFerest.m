function [ class, posterior ] = evaluateFerest( testLists, histogramList, testPatch )
%EVALUATEFEREST Summary of this function goes here
%   Detailed explanation goes here

sizeLists = size(testLists);
numFerns = sizeLists(1);


sHisto = size(histogramList{1});
numClasses = sHisto(1);
posterior = ones(numClasses,1);


for i=1:numFerns
    [~,new_posterior] = evaluateFern( testLists{i}, histogramList{i}, testPatch );
    posterior = posterior.*new_posterior;
end


%normalize distribution
sumPosterior = sum(posterior);
for i=1:numClasses
    if sumPosterior ~= 0
        posterior(i)= posterior(i)/sumPosterior;
    else
        posterior(i)=1/numClasses;
    end
end
posterior';

[~, class] = max(posterior);
% [maxValue, class] = max(posterior);
% maxValue
% class

end

