%% Ferest Tests
maxDepth = 20;
maxFerns = 50;

accuracies = zeros(maxFerns,maxDepth);

startFerestsString = 'Evaluation/Ferests/ferest';
startAccuraciesString = 'Evaluation/Accuracies/accuracy';
matEnd = '.mat';


try
    for i = 1:maxDepth
        numTests = i;
        
        for k = 1:maxFerns
            numFerns = k;
            ferest = Ferest(numFerns, numTests);
            ferest = ferest.trainRandom(train_data, train_labels);
            
            saveString = strcat(startFerestsString,'_',num2str(i), ...
                '_',num2str(j),matEnd);
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
            
            saveString = strcat(startAccuraciesString,'_',num2str(i), ...
                '_',num2str(j),matEnd);
            save(saveString,'accuracy','-v7.3');
            
            accuracies(k,i) = accuracy(1);
        end
        
        saveString = strcat(startAccuraciesString,'_',num2str(i), ...
            '_',num2str(j),matEnd);
        save(saveString,'accuracies','-v7.3');
    end
catch
    saveString = strcat(startAccuraciesString,'_',num2str(i), ...
        '_',num2str(j),matEnd);
    save(saveString,'accuracies','-v7.3');
end

saveString = strcat(startAccuraciesString,'_',num2str(i), ...
    '_',num2str(j),matEnd);
save(saveString,'accuracies','-v7.3');
