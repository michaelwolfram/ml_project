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

        
        function obj = trainRandom(obj, train_data, ...
                train_labels, min_data, max_data)
            % training for a single fern
            
            
            numSamples = size(train_data,1);
            numFeatures = size(train_data,2);
            [obj.classes,indices,~]=unique(train_labels);
            numClasses = size(obj.classes,1);
            indices(numClasses+1) = numSamples+1;
            
            randNumbers = rand([2,obj.numTests]);
            % necessary to generate random letter within min/max range
            smallAlphabet = 'defghijklmnopqrstuvw';
            
            for i = 1:obj.numTests
                randomFeature = round(1 + ((numFeatures-1) * ...
                    randNumbers(1,i)));
                obj.testList{i,1} = randomFeature;
                if randomFeature == 1
                    %generate random char
                    randChar = smallAlphabet(1+round(randNumbers(2,i)*19));
                    obj.testList{i,2} = randChar;
                elseif randomFeature == 2
                    if randNumbers(2,i)<= 0.5
                        obj.testList{i,2} = 'Woman';
                    else
                        obj.testList{i,2} = 'Man';
                    end
                else
                    obj.testList{i,2} = min_data(randomFeature) + ...
                        ((max_data(randomFeature)- ...
                        min_data(randomFeature)) * randNumbers(2,i));
                end
            end
            
            
            for i = 1:numClasses
                for j = indices(i):(indices(i+1)-1)
                    binaryNumber = 1;
                    
                    % add cases for string comparisons
                    
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

