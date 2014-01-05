clc
clear all
close all

%% initial randomized data - can be used to get various data sets
[ train_data,train_labels,valid_data,valid_labels ] ...
    = loadRandomData('../../dataset-har-PUC-Rio-ugulino.csv', ...
    false, 19, true, 2/3);

%% Create a small subset of the initial randomized data.
[ train_data_small,train_labels_small,valid_data_small,valid_labels_small ] ...
    = createSmallRandomData('../../dataset-har-PUC-Rio-ugulino.csv', ...
    true, 19, false, 2/3, 0.001);