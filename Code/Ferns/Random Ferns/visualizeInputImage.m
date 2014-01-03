function [ abc ] = visualizeInputImage( source, keypointList, testLists, histogramList, input1 )
%VISUALIZEINPUTIMAGE Summary of this function goes here
%   Detailed explanation goes here

% sabis robust harris
% generate patch
% evaluateferest
% dataset f?r ransac bauen
% ransac
% urspruengliche rectangle corners transformieren
% visualize

sigma=2;
[gMaskHorz,gMaskVert]=gaussian_1d(sigma);
smoothedH=convolution(input1,gMaskHorz,'mirror');
smoothedHV=convolution(smoothedH,gMaskVert,'mirror');

ResHarris = robustHarrisPoints(smoothedHV,16);

patchSize=[31,31];
numPatches = 500;
numTests = 10;
numFerns = 10;
[keypointList2,patchList2] = keypoints2patches( smoothedHV, ResHarris, patchSize, numPatches);

S = keypointList2';
S = padarray(S,2,0,'pre');

numClasses = size(keypointList2,1);
display('evaluateFerestLoop On')
tic
for i = 1 : numClasses
    currPatch = patchList2{i,1};
    [class, posterior] = evaluateFerest(testLists, histogramList, currPatch);
    S(1,i) = keypointList(class,1);
    S(2,i) = keypointList(class,2);
end
toc
display('vII:evaluateFerestLoop Off')
sampleSize = 4;
sigma2 = 5.0;
tt = 5.99*sigma2;
N = 72;
epsilon = 0.2;
n = 8; % Siehe fp1 und fp2!
T = (1 - epsilon)*n;
display('vII:ransac On')
tic
%[H, bestSample] = ransac(S, sampleSize, tt, T, N);
[H, bestSample] = adaptive_ransac(S, sampleSize, tt);
toc
display('vII:ransac Off')
sourcePoints = [[1 1 500 500]; [1 650 1 650]; [1 1 1 1]];
Hsp = hnormalise(H*sourcePoints);
Hsp = Hsp(1:2,:);
sourcePoints = sourcePoints(1:2,:);

abc = visualize(source,input1,sourcePoints',Hsp');

end

