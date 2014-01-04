classdef Fern
    %FERN Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % a two-column wide column vector that contains the dimension at
        % which we split and the respective value
        testList;
        histograms;
    end
    
    methods
        function obj = Fern()
            obj.testList = {};
            obj.histograms = [];
        end
        
        function trainRandom(obj, train_data, train_labels, min_data, max_data, numTests)
            % training for a single fern
            
            obj.testList = cell(numTests, 2);
            numSamples = size(train_data,1);
            numFeatures = size(train_data,2);
            [classes,indices,~]=unique(train_labels);
            numClasses = size(classes,1);
            indices(numClasses+1) = numSamples;
            
            randNumbers = rand([2,numTests]);
            % necessary to generate random letter within min/max range
            smallAlphabet = 'defghijklmnopqrstuvw';
            
            for i = 1:numTests
                randomFeature = round(1 + ((numFeatures-1) * ...
                    randNumbers(1,i)));
                obj.testList{i,1} = randomFeature;
                if randomFeature == 1
                    %generate random char
                    randChar = smallAlphabet(round(rand(1,1)*26));
                    obj.testList{i,2} = randChar;
                elseif randomFeature == 2
                    if randNumbers(2,i)<= 0.5
                        obj.testList{i,2} = 'Woman';
                    else
                        obj.testList{i,2} = 'Man';
                    end
                else
                    obj.testList{i,2} = round(min_data(i) + ...
                        (max_data(i)-min_data(i) * randNumbers(2,i)));
                end
            end
            
            % we have ones instead of zeros here
            obj.histograms = ones(5,2^numTests);
            for i = 1:numClasses
                for j = indices(i):indices(i+1)
                    binaryNumber = 1;
                    
                    % add cases for string comparisons
                    
                    for k = 1:numTests
                        if ~ischar(train_data{j,obj.testList{k,1}})
                            if train_data{j,obj.testList{k,1}} <= obj.testList{k,2}
                                binaryNumber = binaryNumber + 2^(k-1);
                            end
                        else
                            orderedStrings = sort([train_data{j,obj.testList{k,1}};obj.testList{k,2}]);
                            if strcmp(train_data{j,obj.testList{k,1}},orderedStrings(1,:)) == 1
                                binaryNumber = binaryNumber + 2^(k-1);
                            end
                        end
                    end
                    
                    obj.histograms(i,binaryNumber) = ...
                        obj.histograms(i,binaryNumber) + 1;
                end
            end
        end
        
        
        
        function [class, posterior] = evaluate(obj, sample)
            % evaluate a single fern
            numTests=size(obj.testList(:,1));
            
            %create binary number
            binaryNumber = 1;
            
            for k = 1:numTests
                if ~ischar(sample{obj.testList{k,1}})
                    if sample{obj.testList{k,1}} <= obj.testList{k,2}
                        binaryNumber = binaryNumber + 2^(k-1);
                    end
                else
                    orderedStrings = sort([sample{obj.testList{k,1}};obj.testList{k,2}]);
                    if strcmp(sample{obj.testList{k,1}},orderedStrings(1,:)) == 1
                        binaryNumber = binaryNumber + 2^(k-1);
                    end
                end
            end
            
            %prepare posterior
            sHisto = size(obj.histograms);
            numClasses = sHisto(1);
            posterior = zeros(numClasses,1);
            
            %normalize distribution
            sumClassProbability = sum(obj.histograms(:,binaryNumber))
            for i=1:numClasses
                %                 if sumClassProbability == 0
                %                     posterior(i)= 1/numClasses
                %                 else
                posterior(i)= obj.histograms(i,binaryNumber)/sumClassProbability
                %                 end
                
            end
            posterior'
            
            [~, class] = max(posterior)
        end
    end
    
    methods(Access=private)
        function cmp = cstrcmp( a, b )
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

