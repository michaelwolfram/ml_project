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
        
        function obj = trainRandom(obj, train_data, train_labels)
            
            [obj.classes,~,~]=unique(train_labels);
            min_data(3:18) = min(cell2mat(train_data(:,3:18)));
            max_data(3:18) = max(cell2mat(train_data(:,3:18)));
            
            for i = 1:obj.numFerns
                tic
                obj.fernList{i} = obj.fernList{i}. ...
                    trainRandom(train_data, train_labels, ...
                    min_data, max_data);
                display('Elapsed time for the training of one FERN:')
                toc
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

