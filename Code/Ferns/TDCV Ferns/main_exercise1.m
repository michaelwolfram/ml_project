%EXERCISE 1 IN TRACKING&DETECTION EXERCISE SHEET 5, November 24, 2013

clc
close all
clear all

% Importation of the Image
coloredSource=im2double(imread('imagesequence/img1.ppm'));
source=rgb2gray(coloredSource);
figure('name','Original Image in grayscale')
imshow(source);

%choose a rectangular pattern in the image, containing only the relevant
%grafitti part
source_cropped = source(1:500,1:650);

%As suggested in the exercise statement, let's smoothe the image before
%looking for the keypoints using the Harris Corner Detector
%This is a rip of from ex 2, sheet 1, using the 1d gaussian mask creator.
%The convolution function is ours, should we used MATLAB's instead?

sigma=2;

[gMaskHorz,gMaskVert]=gaussian_1d(sigma);
smoothedH=convolution(source_cropped,gMaskHorz,'mirror');
smoothedHV=convolution(smoothedH,gMaskVert,'mirror');

%we're using our own implementation of the robust harris corner detector
display('Robust Harris Corner Detection:')
tic
ResHarris = robustHarrisPoints(smoothedHV,16);
toc

% Construction of the Patches
patchSize=[31,31]; %30x30 to 50x50
numPatches = 500;
numTests = 10;
numFerns = 10;
display('Keypoints to Patches:')
tic
[keypointList,patchList] = keypoints2patches( smoothedHV, ResHarris, patchSize, numPatches);
toc

%train ferns using the given data
display('Train Fern:')
tic
[testLists,histogramList] = trainFerest(numTests,numFerns,patchList);
%[testList,histograms] = trainFern(numTests,patchList);
toc

inputTmp=im2double(imread('imagesequence/img2.ppm'));
input1=rgb2gray(inputTmp);
display('Visualize Input Image:')
% tic
% visualizeInputImage(source, keypointList, testLists, histogramList, input1);
% toc
%% Visualize InputImage source, keypointList, testLists, histogramList, input1 )
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
%% EvaluateFerestLoop
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
S

% sampleSize = 4;
% sigma2 = 5.0;
% tt = 5.99*sigma2;
% N = 72;
% epsilon = 0.2;
% n = 8; % Siehe fp1 und fp2!
% T = (1 - epsilon)*n;
% display('vII:ransac On')
% tic
% %[H, bestSample] = ransac(S, sampleSize, tt, T, N);
% [H, bestSample] = adaptive_ransac(S, sampleSize, tt);
% toc
% display('vII:ransac Off')
% sourcePoints = [[1 1 500 500]; [1 650 1 650]; [1 1 1 1]];
% Hsp = hnormalise(H*sourcePoints);
% Hsp = Hsp(1:2,:);
% sourcePoints = sourcePoints(1:2,:);
% 
% 
% 
% abc = visualize(source,input1,sourcePoints',Hsp');

abc = visualize(source,input1,S(1:2, :)',S(3:4, :)');

% visualizeInputImage(source, keypointList, testLists, histogramList, 'imagesequence/img3.ppm');
% visualizeInputImage(source, keypointList, testLists, histogramList, 'imagesequence/img4.ppm');
% visualizeInputImage(source, keypointList, testLists, histogramList, 'imagesequence/img5.ppm');
% visualizeInputImage(source, keypointList, testLists, histogramList, 'imagesequence/img6.ppm');
