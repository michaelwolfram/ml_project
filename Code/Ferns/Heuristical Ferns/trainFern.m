function [ testList, histograms ] = trainFern( numTests, patchList )
%TRAINFERN this function simulates the behaviour of a single fern
%using random tests and the given patchlist

%initialize tests and variables
patchListSize = size(patchList);
patchSize = size(patchList{1,1});
testList = zeros(numTests, 4);

for i=1:numTests
    randomChoiceX = round(patchSize(2)*rand(2,1));
    randomChoiceY = round(patchSize(1)*rand(2,1));
    
    rXone=randomChoiceX(1);
    rXtwo=randomChoiceX(2);
    if rXone == 0
        rXone = 1;
    end
    if rXtwo == 0
        rXtwo = 1;
    end
    
    testList(i,1)=rXone;
    testList(i,3)=rXtwo;
    
    rYone=randomChoiceY(1);
    rYtwo=randomChoiceY(2);
    if rYone == 0
        rYone = 1;
    end
    if rYtwo == 0
        rYtwo = 1;
    end
    
    testList(i,2)=rYone;
    testList(i,4)=rYtwo;
end

%apply random tests
numPatches = patchListSize(2);
numClasses = patchListSize(1);
%numTests;
numBuckets = 2^numTests;

histograms = zeros(numClasses, numBuckets);

for i=1:numClasses
    for j=1:numPatches
        %create binary number
        binNumber=1;
        for k=1:numTests
            if patchList{i,j}(testList(k,2),testList(k,1)) ...
                    <= patchList{i,j}(testList(k,4),testList(k,3))
                %adjust binary number
                binNumber=binNumber+2^(k-1);
            end
        end
        %         display('Writing into bin number');
        %         histogramNumber
        %         binNumber
        %adjust histogram
        histograms(i,binNumber) = histograms(i,binNumber) + 1;
    end
end

%normalize the histograms class-wise
for i=1:numClasses
    classSum = sum(histograms(i,:));
    for j=1:numBuckets
        histograms(i,j)=histograms(i,j)/classSum;
    end
end
%histograms

end

