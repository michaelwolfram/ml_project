%% Ferest Tests
maxDepth = 12;
maxFerns = 10;

randomAccuracies = zeros(maxFerns,maxDepth);
giniAccuracies = zeros(maxFerns,maxDepth);
times = zeros(3,maxDepth);

startRandomFerestsString = 'Evaluation/RandomFerests/randomFerest';
startGiniFerestsString = 'Evaluation/RandomFerests/giniFerest';
startRandomAccuracyString = 'Evaluation/Accuracy/Random/accuracy';
startRandomAccuraciesString = 'Evaluation/Accuracies/Random/accuracy';
startGiniAccuracyString = 'Evaluation/Accuracy/Gini/accuracy';
startGiniAccuraciesString = 'Evaluation/Accuracies/Gini/accuracy';
matEnd = '.mat';


% try
    for i = 10:2:maxDepth
        if i==0
            numTests = 1;
        else
            numTests = i;
        end
        
        for k = 0:5:maxFerns
            if k == 0
                numFerns = 1;
            else
                numFerns = k;
            end
            randomFerest = Ferest(numFerns, numTests);
            tic
            randomFerest = randomFerest.trainMeanRandom(train_data, train_labels);
            times(1,numTests) = toc;
            
            saveString = strcat(startRandomFerestsString,'_',num2str(numTests), ...
                '_',num2str(numFerns),matEnd);
            save(saveString,'randomFerest','-v7.3');
            
            
            tic
            accuracy = [0, 0];
            for j = 1:size(valid_data,1)
                sample = valid_data(j,:);
                [class, ~] = randomFerest.evaluate(sample);
                if strcmp(class,valid_labels{j}) == 1
                    accuracy(1) = accuracy(1)+1;
                else
                    accuracy(2) = accuracy(2)+1;
                end
            end
            accuracy = accuracy/sum(accuracy);
            times(3,numTests) = toc;
            
            saveString = strcat(startRandomAccuracyString,'_',num2str(numTests), ...
                '_',num2str(numFerns),matEnd);
            save(saveString,'accuracy','-v7.3');
            
            randomAccuracies(numFerns,numTests) = accuracy(1);
            
            
            
            
            giniFerest = Ferest(numFerns, numTests);
            tic
            giniFerest = giniFerest.trainBestGini(train_data, train_labels);
            times(2,numTests) = toc;
            
            saveString = strcat(startGiniFerestsString,'_',num2str(numTests), ...
                '_',num2str(numFerns),matEnd);
            save(saveString,'giniFerest','-v7.3');
            
            tic
            accuracy = [0, 0];
            for j = 1:size(valid_data,1)
                sample = valid_data(j,:);
                [class, ~] = giniFerest.evaluate(sample);
                if strcmp(class,valid_labels{j}) == 1
                    accuracy(1) = accuracy(1)+1;
                else
                    accuracy(2) = accuracy(2)+1;
                end
            end
            accuracy = accuracy/sum(accuracy);
            times(3,numTests) = toc
            
            saveString = strcat(startGiniAccuracyString,'_',num2str(numTests), ...
                '_',num2str(numFerns),matEnd);
            save(saveString,'accuracy','-v7.3');
            
            giniAccuracies(numFerns,numTests) = accuracy(1);
        end
        
        saveString = strcat(startRandomAccuraciesString,'_',num2str(i), ...
            '_',num2str(k),matEnd);
        save(saveString,'randomAccuracies','-v7.3');
        
        saveString = strcat(startGiniAccuraciesString,'_',num2str(i), ...
            '_',num2str(k),matEnd);
        save(saveString,'giniAccuracies','-v7.3');
    end
% catch
%     saveString = strcat(startRandomAccuraciesString,'_',num2str(i), ...
%             '_',num2str(k),matEnd);
%         save(saveString,'randomAccuracies','-v7.3');
%         
%         saveString = strcat(startGiniAccuraciesString,'_',num2str(i), ...
%             '_',num2str(k),matEnd);
%         save(saveString,'giniAccuracies','-v7.3');
% end

saveString = strcat(startRandomAccuraciesString,'_',num2str(i), ...
            '_',num2str(k),matEnd);
        save(saveString,'randomAccuracies','-v7.3');
        
        saveString = strcat(startGiniAccuraciesString,'_',num2str(i), ...
            '_',num2str(k),matEnd);
        save(saveString,'giniAccuracies','-v7.3');
