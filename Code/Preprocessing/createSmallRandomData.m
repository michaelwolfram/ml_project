function [ train_data_small,train_labels_small,valid_data_small,valid_labels_small ] ...
    = createSmallRandomData(path,loadData,columns,saveSets,trainValidateClassRatio,percentage)
%CREATESMALLRANDOMDATA
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
    % convert entries to double precision
    data(:,3:18) = cellfun(@str2double,data(:,3:18),'un',0);
    fclose(fid);
    
    save('data/data.mat','data');
else
    %% (optional) load previously saved data from file
    
    load('data/data.mat');
end;

%% IMPORTANT: when accessing data of the training/validation sets, use {}
%% randomize data and return appropriate sets

% random permutation of the dataset
data = data(randperm(length(data)),:);

% create subsets for each class:
% select all 'sitting' samples from randomly permuted dataset
sitting = data(strcmp('sitting',data(:,columns)),:);
tmpNumSitting = size(sitting,1);
sitting = sitting(1:round(percentage*tmpNumSitting),:);
numSitting = size(sitting,1);
% select desired ratio for training and validation set
sittingTrain = sitting(1:round(numSitting*trainValidateClassRatio),:);
sittingVal = sitting(round(numSitting*trainValidateClassRatio)+1:end,:);

% continue as above..
sittingdown = data(strcmp('sittingdown',data(:,columns)),:);
tmpNumSittingdown = size(sittingdown,1);
sittingdown = sittingdown(1:round(percentage*tmpNumSittingdown),:);
numSittingdown = size(sittingdown,1);
sittingdownTrain = sittingdown(1:round(numSittingdown*trainValidateClassRatio),:);
sittingdownVal = sittingdown(round(numSittingdown*trainValidateClassRatio)+1:end,:);

standing = data(strcmp('standing',data(:,columns)),:);
tmpNumStanding = size(standing,1);
standing = standing(1:round(percentage*tmpNumStanding),:);
numStanding = size(standing,1);
standingTrain = standing(1:round(numStanding*trainValidateClassRatio),:);
standingVal = standing(round(numStanding*trainValidateClassRatio)+1:end,:);

standingup = data(strcmp('standingup',data(:,columns)),:);
tmpNumStandingup = size(standingup,1);
standingup = standingup(1:round(percentage*tmpNumStandingup),:);
numStandingup = size(standingup,1);
standingupTrain = standingup(1:round(numStandingup*trainValidateClassRatio),:);
standingupVal = standingup(round(numStandingup*trainValidateClassRatio)+1:end,:);

walking = data(strcmp('walking',data(:,columns)),:);
tmpNumWalking = size(walking,1);
walking = walking(1:round(percentage*tmpNumWalking),:);
numWalking = size(walking,1);
walkingTrain = walking(1:round(numWalking*trainValidateClassRatio),:);
walkingVal = walking(round(numWalking*trainValidateClassRatio)+1:end,:);
% until here :)


% combine seperate training subsets and divide into data and labels
train_data_small = [sittingTrain(:,1:columns-1); ...
    sittingdownTrain(:,1:columns-1); standingTrain(:,1:columns-1); ...
    standingupTrain(:,1:columns-1); walkingTrain(:,1:columns-1)];
train_labels_small = [sittingTrain(:,columns); ...
    sittingdownTrain(:,columns); standingTrain(:,columns); ...
    standingupTrain(:,columns); walkingTrain(:,columns)];
valid_data_small = [sittingVal(:,1:columns-1); ...
    sittingdownVal(:,1:columns-1); standingVal(:,1:columns-1); ...
    standingupVal(:,1:columns-1); walkingVal(:,1:columns-1)];
valid_labels_small = [sittingVal(:,columns); ...
    sittingdownVal(:,columns); standingVal(:,columns); ...
    standingupVal(:,columns); walkingVal(:,columns)];

if saveSets
    save('data/train_data_small.mat','train_data_small');
    save('data/train_labels_small.mat','train_labels_small');
    save('data/valid_data_small.mat','valid_data_small');
    save('data/valid_labels_small.mat','valid_labels_small');
end

end

