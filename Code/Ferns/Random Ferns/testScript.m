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

% numFerns = 10;
% numTests = 10;
% ferest = Ferest(numFerns, numTests);
% tic
% ferest = ferest.trainRandom(train_data, train_labels);
% display('Elapsed time for the training of the FEREST:')
% toc


% left entry for correct, right for wrong :)
accuracy = [0, 0];
tic
for i = 1:size(train_data,1)
    sample = train_data(i,:);
    [class, posterior] = ferest.evaluate(sample);
    if strcmp(class,train_labels{i}) == 1
        accuracy(1) = accuracy(1)+1;
    else
        accuracy(2) = accuracy(2)+1;
    end
end
display('Elapsed time for evaluation of the training set:');
toc
accuracy = accuracy/sum(accuracy)