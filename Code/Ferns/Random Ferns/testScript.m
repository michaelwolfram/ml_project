numTests = 10;
min_data(3:18) = min(cell2mat(train_data(:,3:18)));
max_data(3:18) = max(cell2mat(train_data(:,3:18)));

fern = Fern();
fern = fern.trainRandom(train_data, train_labels, min_data, max_data, numTests)


for i = 1:10
    fern.evaluate(valid_data(i,:));
end
