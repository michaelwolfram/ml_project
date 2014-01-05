classdef Fern
    %FERN Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        numTests;
        
        % a two-column wide column vector that contains the dimension at
        % which we split and the respective value
        testList;
        histograms;
        classes;
    end
    
    methods
        function obj = Fern(numTests)
            obj.testList = cell(numTests, 2);
            obj.histograms = zeros(5,2^numTests);
            obj.numTests = numTests;
        end
        
        
        function obj = trainMeanRandom(obj, train_data, train_labels)
            % training for a single fern using the proposed method of
            % finding a threshold by using the mean of two random
            % picks within the given training set
            
            
            numSamples = size(train_data,1);
            numFeatures = size(train_data,2);
            [obj.classes,indices,~]=unique(train_labels);
            numClasses = size(obj.classes,1);
            indices(numClasses+1) = numSamples+1;
            
            % as we're using random subset selection of the feature
            % dimension, d < D :)
            if obj.numTests >= numClasses
                obj.numTests = numClasses - 1;
            end
            
            
            featureSubset = randperm(numFeatures);
            randNumbers = rand([2,obj.numTests]);
            % necessary to generate random letter within min/max range
            smallAlphabet = 'defghijklmnopqrstuvw';
            
            for i = 1:obj.numTests
                randomFeature = featureSubset(i);% take the feature fiven above
                obj.testList{i,1} = randomFeature;
                if randomFeature == 1
                    % generate random char
                    randChar = smallAlphabet(1+round(randNumbers(1,i)*19));
                    obj.testList{i,2} = randChar;
                elseif randomFeature == 2
                    if randNumbers(1,i)<= 0.5
                        obj.testList{i,2} = 'Woman';
                    else
                        obj.testList{i,2} = 'Man';
                    end
                else
                    % changed to mean here
                    obj.testList{i,2} = (train_data{randomFeature, ...
                        (1+randNumbers(1,i)*numFeatures)} + ...
                        train_data{randomFeature, ...
                        (1+randNumbers(2,i)*numFeatures)}) / 2;
                end
            end
            
            
            for i = 1:numClasses
                for j = indices(i):(indices(i+1)-1)
                    binaryNumber = 1;
                    
                    for k = 1:obj.numTests
                        if ~ischar(train_data{j,obj.testList{k,1}})
                            if train_data{j,obj.testList{k,1}} <= obj.testList{k,2}
                                binaryNumber = binaryNumber + 2^(k-1);
                            end
                        else
                            orderedStrings = sort({train_data{j,obj.testList{k,1}};obj.testList{k,2}});
                            if Fern.cstrcmp(train_data{j,obj.testList{k,1}},orderedStrings{1}) <= 0
                                binaryNumber = binaryNumber + 2^(k-1);
                            end
                        end
                    end
                    
                    obj.histograms(i,binaryNumber) = ...
                        obj.histograms(i,binaryNumber) + 1;
                end
                % normalize the histogram to get an actual probability
                for l = 1:(2^obj.numTests)
                    obj.histograms(i,l) = (obj.histograms(i,l) + 1) / ...
                        (indices(i+1)-indices(i) + (2^obj.numTests));
                end
            end
        end
        
        
        
        function obj = trainBestGini(obj, train_data, train_labels)
            % training for a single fern using a heuristical approach
            % for finding the best threshold within a given dimension
            
            
            numSamples = size(train_data,1);
            numFeatures = size(train_data,2);
            [obj.classes,indices,~]=unique(train_labels);
            numClasses = size(obj.classes,1);
            indices(numClasses+1) = numSamples+1;
            
            % as we're using random subset selection of the feature
            % dimension, d < D :)
            if obj.numTests >= numClasses
                obj.numTests = numClasses - 1;
            end
            
            featureSubset = randperm(numFeatures);
            
            for i = 1:obj.numTests
                % take the feature fiven above
                randomFeature = featureSubset(i);
                obj.testList{i,1} = randomFeature;
                
                obj.testList{i,2} = obj.findBestThreshold(train_data,train_labels);
            end
            
            
            for i = 1:numClasses
                for j = indices(i):(indices(i+1)-1)
                    binaryNumber = 1;
                    
                    for k = 1:obj.numTests
                        if ~ischar(train_data{j,obj.testList{k,1}})
                            if train_data{j,obj.testList{k,1}} <= obj.testList{k,2}
                                binaryNumber = binaryNumber + 2^(k-1);
                            end
                        else
                            orderedStrings = sort({train_data{j,obj.testList{k,1}};obj.testList{k,2}});
                            if Fern.cstrcmp(train_data{j,obj.testList{k,1}},orderedStrings{1}) <= 0
                                binaryNumber = binaryNumber + 2^(k-1);
                            end
                        end
                    end
                    
                    obj.histograms(i,binaryNumber) = ...
                        obj.histograms(i,binaryNumber) + 1;
                end
                % normalize the histogram to get an actual probability
                for l = 1:(2^obj.numTests)
                    obj.histograms(i,l) = (obj.histograms(i,l) + 1) / ...
                        (indices(i+1)-indices(i) + (2^obj.numTests));
                end
            end
        end
        
        
        
        function [class, posterior] = evaluate(obj, sample)
            % evaluate a single fern
            
            %create binary number
            binaryNumber = 1;
            
            for k = 1:obj.numTests
                if ~ischar(sample{obj.testList{k,1}})
                    if sample{obj.testList{k,1}} <= obj.testList{k,2}
                        binaryNumber = binaryNumber + 2^(k-1);
                    end
                else
                    orderedStrings = sort({sample{obj.testList{k,1}};obj.testList{k,2}});
                    if Fern.cstrcmp(sample{obj.testList{k,1}},orderedStrings{1}) <= 0
                        binaryNumber = binaryNumber + 2^(k-1);
                    end
                end
            end
            
            %prepare posterior
            sHisto = size(obj.histograms);
            numClasses = sHisto(1);
            posterior = zeros(1, numClasses);
            
            %normalize distribution
            sumClassProbability = sum(obj.histograms(:,binaryNumber));
            for i=1:numClasses
                posterior(i)= obj.histograms(i,binaryNumber) / ...
                    sumClassProbability;
            end
            %display(posterior)
            
            [~, classNumber] = max(posterior);
            class = obj.classes(classNumber);
            
        end
    end
    
    methods (Access = private)
        function featureValue=findBestThreshold(obj,train_data,...
                train_labels,featureDimension)
            curr_i = 0;
            curr_j = 0;
            curr_costs = inf;
            for i=1:size(train_data,1)
                if ~isempty(find(obj.validDimensions==j,1))
                    [left,right] = obj.splitTreePi(j,i,train_data,train_labels);
                    tmp = obj.calcNewCosts(left,right);
                    if tmp < curr_costs
                        curr_i = i;
                        curr_j = j;
                        curr_costs = tmp;
                    end
                end
            end
            featureDimension = curr_j;
            featureValue = curr_i;
            splitCosts = curr_costs;
        end
    end
    
    methods (Static = true)
        
        function cmp = cstrcmp(a, b )
            % The output is:
            %  a == b : 0
            %  a > b  : positive
            %  a < b  : negative
            
            % Force the strings to equal length
            x = char({a;b});
            % Subtract one from the other
            d = x(1,:) - x(2,:);
            % Remove zero entries
            d(~d) = [];
            if isempty(d)
                cmp = 0;
            else
                cmp = d(1);
            end
        end
    end
end

