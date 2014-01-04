%% Ferest Tests
maxDepth = 4;
maxFerns = 2;

ferests = cell(maxFerns,maxDepth);
accuracies = zeros(maxFerns,maxDepth);

try
    for i = 1:maxDepth
        numTests = i;
        
        for k = 1:maxFerns
            numFerns = k;
            ferests{k,i} = Ferest(numFerns, numTests);
            ferests{k,i} = ferests{k,i}.trainRandom(train_data, train_labels);
            
            accuracy = [0, 0];
            for j = 1:size(valid_data,1)
                sample = valid_data(j,:);
                [class, ~] = ferests{k,i}.evaluate(sample);
                if strcmp(class,valid_labels{j}) == 1
                    accuracy(1) = accuracy(1)+1;
                else
                    accuracy(2) = accuracy(2)+1;
                end
            end
            accuracy = accuracy/sum(accuracy);
            accuracies(k,i) = accuracy(1);
        end
    end
catch
    save('Evaluation/ferestsMaxMax.mat','ferests')
    save('Evaluation/accuraciesMaxMax.mat','accuracies')
end