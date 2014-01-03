function [ testLists, histogramList ] = trainFerest( numTests, numFerns, patchList )
%TRAINFEREST Summary of this function goes here
%   Detailed explanation goes here

testLists = cell(numFerns,1);
histogramList = cell(numFerns,1);

for i=1:numFerns
   [testList,histograms] = trainFern(numTests,patchList);
   testLists{i}=testList;
   histogramList{i}=histograms;
end

end

