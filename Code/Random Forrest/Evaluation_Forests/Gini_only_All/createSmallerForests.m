%% Create small tree cell.
smallerForests={1,18};

for i=1:18
    smallerForests{i} = forest;
    smallerForests{i}.numTrees = i;
    smallerForests{i}.trainedTrees = ones(1,i);
    smallerForests{i}.trees = forest.trees(1:i);
end

%% Load training times.
accuracies_all=zeros(1,18);
timesTrain_all=zeros(1,18);
timesTest_all=zeros(1,18);

startAccuraciesString = 'Evaluation_Forests/Gini_only_All/Accuracies/accuracies_gini_6_';
startTrainString = 'Evaluation_Forests/Gini_only_All/Accuracy/accuracy_gini_6_';
matEnd = '.mat';

for i=1:18
    loadString = strcat(startAccuraciesString,num2str(i),'_',matEnd);
    load(loadString);
    accuracies_all(i) = accuracy;
    timesTest_all(i) = Ttest;
    
    loadString = strcat(startTrainString,num2str(i),'_',matEnd);
    load(loadString);
    timesTrain_all(i) = Ttrain;
end

saveString = strcat('Evaluation_Forests/Gini_only_All/all_data_inside');
save(saveString,'accuracies_all','timesTrain_all','timesTest_all');