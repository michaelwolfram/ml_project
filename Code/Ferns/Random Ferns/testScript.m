numTests = 5;
min_data = min(cell2mat(train_data));
max_data = max(cell2mat(train_data));

fern = Fern();
fern.trainRandom(train_data, train_labels, min_data, max_data, numTests)