%% Ferest Tests
maxDepth = 12;
maxFerns = 100;

accuracies = zeros(maxFerns,maxDepth);

startFerestsString = 'Evaluation/Ferests/ferest';
startAccuracyString = 'Evaluation/Accuracy/accuracy';
startAccuraciesString = 'Evaluation/Accuracies/accuracy';
matEnd = '.mat';


try
    for i = 8:2:maxDepth
        if i==0
            numTests = 1;
        else
            numTests = i;
        end
        
        for k = 40:10:maxFerns
            if k == 0
                numFerns = 1;
            else
                numFerns = k;
            end
            
            if i == 14 && k<=20
                continue;
            end
            
            ferest = Ferest(numFerns, numTests);
            ferest = ferest.trainRandom(train_data, train_labels);
            
            saveString = strcat(startFerestsString,'_',num2str(numTests), ...
                '_',num2str(numFerns),matEnd);
            save(saveString,'ferest','-v7.3');
            
            
            accuracy = [0, 0];
            for j = 1:size(valid_data,1)
                sample = valid_data(j,:);
                [class, ~] = ferest.evaluate(sample);
                if strcmp(class,valid_labels{j}) == 1
                    accuracy(1) = accuracy(1)+1;
                else
                    accuracy(2) = accuracy(2)+1;
                end
            end
            accuracy = accuracy/sum(accuracy);
            
            saveString = strcat(startAccuracyString,'_',num2str(numTests), ...
                '_',num2str(numFerns),matEnd);
            save(saveString,'accuracy','-v7.3');
            
            accuracies(numFerns,numTests) = accuracy(1);
        end
        
        saveString = strcat(startAccuraciesString,'_',num2str(i), ...
            '_',num2str(k),matEnd);
        save(saveString,'accuracies','-v7.3');
    end
catch exc
    getReport(exc)
    saveString = strcat(startAccuraciesString,'_',num2str(i), ...
        '_',num2str(k),matEnd);
    save(saveString,'accuracies','-v7.3');
end

saveString = strcat(startAccuraciesString,'_',num2str(i), ...
    '_',num2str(j),matEnd);
save(saveString,'accuracies','-v7.3');
