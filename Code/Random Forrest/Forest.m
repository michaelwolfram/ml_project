classdef Forest
    %FOREST Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % Number of trees in this forest.
        numTrees;
        % Cell array containing all trees of this forest.
        trees;
        % Number of valid dimensions.
        validDimSize;
        % Percentage of the size of the training data used for training a
        % single tree.
        percentage;
    end
    
    methods
        function obj = Forest(numTrees, percentage, validDimSize,...
                impurityMeasure, varargin)
            obj.numTrees = numTrees;
            obj.percentage = percentage;
            obj.validDimSize = validDimSize;
            for i=1:numTrees
                obj.trees{i} = BinaryTree(impurityMeasure, varargin{:});
            end
        end
        
        function obj = train(obj, train_data, train_labels)
            for i=1:obj.numTrees
                % Generate random train set for each tree with replacement.
                numTrainData = length(train_data);
                
                permutationWithReplacement = randi(numTrainData,1,numTrainData);
                
                train_data = train_data(permutationWithReplacement,:);
                train_labels = train_labels(permutationWithReplacement,:);
                
                curr_train_data = train_data(1:round(obj.percentage*numTrainData),:);
                curr_train_labels = train_labels(1:round(obj.percentage*numTrainData),:);
                
%                 % create subsets for each class:
%                 % select all 'sitting' samples from randomly permuted dataset
%                 sitting = train_data(strcmp('sitting',train_data(:,columns)),:);
%                 tmpNumSitting = size(sitting,1);
%                 sitting = sitting(1:round(obj.percentage*tmpNumSitting),:);
%                 
%                 sittingdown = train_data(strcmp('sittingdown',train_data(:,columns)),:);
%                 tmpNumSittingdown = size(sittingdown,1);
%                 sittingdown = sittingdown(1:round(obj.percentage*tmpNumSittingdown),:);
%                 
%                 standing = train_data(strcmp('standing',train_data(:,columns)),:);
%                 tmpNumStanding = size(standing,1);
%                 standing = standing(1:round(obj.percentage*tmpNumStanding),:);
%                 
%                 standingup = train_data(strcmp('standingup',train_data(:,columns)),:);
%                 tmpNumStandingup = size(standingup,1);
%                 standingup = standingup(1:round(obj.percentage*tmpNumStandingup),:);
%                 
%                 walking = train_data(strcmp('walking',train_data(:,columns)),:);
%                 tmpNumWalking = size(walking,1);
%                 walking = walking(1:round(obj.percentage*tmpNumWalking),:);
%                 
%                 % combine seperate training subsets and divide into data and labels
%                 curr_train_data = [sitting(:,1:columns-1); ...
%                     sittingdown(:,1:columns-1); standing(:,1:columns-1); ...
%                     standingup(:,1:columns-1); walking(:,1:columns-1)];
%                 curr_train_labels = [sitting(:,columns); ...
%                     sittingdown(:,columns); standing(:,columns); ...
%                     standingup(:,columns); walking(:,columns)];
                
                % Generate random subset of valid dimensions for this tree.
                permutatedDimensions = randperm(size(train_data,2));
                
                % Train a single tree.
                obj.trees{i} = obj.trees{i}.train(curr_train_data,...
                    curr_train_labels,permutatedDimensions(1:obj.validDimSize));
            end
        end
        
        function[classification,classCertainty] = classify(obj, featureVector)
            classArray = cell(1,obj.numTrees);
            for i=1:obj.numTrees
                [classArray{i},~] = obj.trees{i}.classify(featureVector);
            end
            [unique_classes,~,map] = unique(classArray);
            classification = unique_classes(mode(map));
            classCertainty = numel(find(strcmp(classArray,classification)))...
                / obj.numTrees;
        end
    end
    
end

