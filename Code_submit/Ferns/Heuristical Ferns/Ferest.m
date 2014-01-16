classdef Ferest
    %FEREST
    % A forest of ferns is a ferest :)
    
    properties
        numFerns;
        numTests;
        classes;
        
        testLists;
        histogramList;
        fernList;
    end
    
    methods
        function obj = Ferest(numFerns, numTests)
            obj.testLists = cell(1,numFerns);
            obj.histogramList = cell(1,numFerns);
            obj.fernList = cell(1,numFerns);
            
            for i = 1:numFerns
                obj.fernList{i} = Fern(numTests);
            end
            
            obj.numFerns = numFerns;
            obj.numTests = numTests;
        end
        
        function obj = trainMeanRandom(obj, train_data, train_labels)
            numTrainData = length(train_data);
            [obj.classes,~,~]=unique(train_labels);
            
            for i = 1:obj.numFerns
                permutationWithReplacement = randi(numTrainData,1,numTrainData);
                
                train_data = train_data(permutationWithReplacement,:);
                train_labels = train_labels(permutationWithReplacement,:);
                
                [~, ii] = sort(train_labels);
                train_labels = train_labels(ii);
                train_data = train_data(ii,:);
                
                
                obj.fernList{i} = obj.fernList{i}.trainMeanRandom(train_data, train_labels);
                obj.testLists{i} = obj.fernList{i}.testList;
                obj.histogramList{i} = obj.fernList{i}.histograms;
            end
            
        end
        
        function obj = trainBestGini(obj, train_data, train_labels)
            numTrainData = length(train_data);
            [obj.classes,~,~]=unique(train_labels);
            
            for i = 1:obj.numFerns
                permutationWithReplacement = randi(numTrainData,1,numTrainData);
                
                train_data = train_data(permutationWithReplacement,:);
                train_labels = train_labels(permutationWithReplacement,:);
                
                [~, ii] = sort(train_labels);
                train_labels = train_labels(ii);
                train_data = train_data(ii,:);
                
                obj.fernList{i} = obj.fernList{i}. ...
                    trainBestGini(train_data, train_labels);
                obj.testLists{i} = obj.fernList{i}.testList;
                obj.histogramList{i} = obj.fernList{i}.histograms;
            end
            
        end
        
        function [class, posterior] = evaluate(obj, sample)
            
            numClasses = size(obj.histogramList{1},1);
            posterior = ones(1, numClasses);
            
            % tic
            for i=1:obj.numFerns
                % tic
                [~,new_posterior] = obj.fernList{i}.evaluate(sample);
                % display('Elapsed time for the evaluation of one FERN:')
                % toc
                posterior = posterior.*new_posterior;
            end
            % display('Elapsed time for the evaluation of the FEREST:')
            % toc
            
            % normalize distribution
            sumPosterior = sum(posterior);
            for i=1:numClasses
                posterior(i)= posterior(i)/sumPosterior;
            end
            % display(posterior)
            
            [~, classNumber] = max(posterior);
            class = obj.classes(classNumber);
            
        end
    end
    
end

