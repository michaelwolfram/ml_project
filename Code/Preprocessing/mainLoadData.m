clc
clear all
close all

% initial randomized data - can be used to get various data sets
[ train_data,train_labels,valid_data,valid_labels ] ...
    = loadRandomData('../../dataset-har-PUC-Rio-ugulino.csv', ...
    false, 19, true, 2/3);