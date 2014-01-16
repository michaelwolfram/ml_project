% numTests = 10;
% min_data(3:18) = min(cell2mat(train_data(:,3:18)));
% max_data(3:18) = max(cell2mat(train_data(:,3:18)));
%
% fern = Fern(numTests);
% fern = fern.trainRandom(train_data, train_labels, min_data, max_data)
%
%
% for i = 1:10
%     fern.evaluate(valid_data(i,:));
% end


%% Ferest Tests
times = zeros(2,100);
ferests = cell(1,100);
numFerns = 3;
numTests = 10;

sample = valid_data(1,:);

numRuns = 25;

for i = 1:numRuns
    ferests{i} = Ferest(numFerns, numTests);
    tic
    ferests{i} = ferests{i}.trainRandom(train_data, train_labels);
    % display('Elapsed time for the training of the FEREST:')
    times(1,i) = toc;
    tic
    ferests{i}.evaluate(sample);
    times(2,i) = toc;
    display(i)
end

save('Evaluation/timesOneOneToHundred.mat','times')
save('Evaluation/ferestsOneOneToHundred.mat','ferests')

% top line for training data, bottom for validation
accuracies = zeros(2,25);

for i = 1:numRuns
    tic
    accuracy = [0, 0];
    for j = 1:size(train_data,1)
        sample = train_data(j,:);
        [class, posterior] = ferests{i}.evaluate(sample);
        if strcmp(class,train_labels{j}) == 1
            accuracy(1) = accuracy(1)+1;
        else
            accuracy(2) = accuracy(2)+1;
        end
    end
    accuracy = accuracy/sum(accuracy);
    accuracies(1,i) = accuracy(1);
    
    
    accuracy = [0, 0];
    for j = 1:size(valid_data,1)
        sample = valid_data(j,:);
        [class, posterior] = ferests{i}.evaluate(sample);
        if strcmp(class,valid_labels{j}) == 1
            accuracy(1) = accuracy(1)+1;
        else
            accuracy(2) = accuracy(2)+1;
        end
    end
    accuracy = accuracy/sum(accuracy);
    accuracies(2,i) = accuracy(1);
    display(i)
    toc
end

save('Evaluation/accuraciesOneOneToTwentyfive.mat','accuracies')