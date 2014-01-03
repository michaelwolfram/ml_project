function [ train_data,train_labels,valid_data,valid_labels ] ...
    = loadRandomData(path,loadData,columns,saveSets,trainValidateClassRatio)
%LOADRANDOMDATA
% this function returns randomized data sets that meet the given
% conditions of a desired ratio between number of classes in the training
% and validation set


%% load initial data from .csv file and save as .mat if indicated by the
%  loadData flag
if(~loadData)
    fid = fopen(path,'r');
    data = textscan(fid, repmat('%s',1,columns), ...
        'delimiter',';', 'CollectOutput',true);
    data = data{1};
    % detete header row
    data = data(2:end,:);
    fclose(fid);
    
    save('data/data.mat','data');
else
    %% (optional) load previously saved data from file
    
    load('data/data.mat');
end;

%% IMPORTANT: when accessing data or the training/validation sets, use {m,n}
%% randomize data and return appropriate sets

% random permutation of the dataset
data = data(randperm(length(data)),:);

% create subsets for each class:
% select all 'sitting' samples from randomly permuted dataset
sitting = data(strcmp('sitting',data(:,columns)),:);
numSitting = size(sitting,1);
% select desired ratio for training and validation set
sittingTrain = sitting(1:round(numSitting*trainValidateClassRatio),:);
sittingVal = sitting(round(numSitting*trainValidateClassRatio)+1:end,:);

% continue as above..
sittingdown = data(strcmp('sittingdown',data(:,columns)),:);
numSittingdown = size(sittingdown,1);
sittingdownTrain = sittingdown(1:round(numSittingdown*trainValidateClassRatio),:);
sittingdownVal = sittingdown(round(numSittingdown*trainValidateClassRatio)+1:end,:);

standing = data(strcmp('standing',data(:,columns)),:);
numStanding = size(standing,1);
standingTrain = standing(1:round(numStanding*trainValidateClassRatio),:);
standingVal = standing(round(numStanding*trainValidateClassRatio)+1:end,:);

standingup = data(strcmp('standingup',data(:,columns)),:);
numStandingup = size(standingup,1);
standingupTrain = standingup(1:round(numStandingup*trainValidateClassRatio),:);
standingupVal = standingup(round(numStandingup*trainValidateClassRatio)+1:end,:);

walking = data(strcmp('walking',data(:,columns)),:);
numWalking = size(walking,1);
walkingTrain = walking(1:round(numWalking*trainValidateClassRatio),:);
walkingVal = walking(round(numWalking*trainValidateClassRatio)+1:end,:);
% until here :)


% combine seperate training subsets and divide into data and labels
train_data = [sittingTrain(:,1:columns-1); ...
    sittingdownTrain(:,1:columns-1); standingTrain(:,1:columns-1); ...
    standingupTrain(:,1:columns-1); walkingTrain(:,1:columns-1)];
train_labels = [sittingTrain(:,columns); ...
    sittingdownTrain(:,columns); standingTrain(:,columns); ...
    standingupTrain(:,columns); walkingTrain(:,columns)];
valid_data = [sittingVal(:,1:columns-1); ...
    sittingdownVal(:,1:columns-1); standingVal(:,1:columns-1); ...
    standingupVal(:,1:columns-1); walkingVal(:,1:columns-1)];
valid_labels = [sittingVal(:,columns); ...
    sittingdownVal(:,columns); standingVal(:,columns); ...
    standingupVal(:,columns); walkingVal(:,columns)];

if saveSets
    save('data/train_data.mat','train_data');
    save('data/train_labels.mat','train_labels');
    save('data/valid_data.mat','valid_data');
    save('data/valid_labels.mat','valid_labels');
end

end

