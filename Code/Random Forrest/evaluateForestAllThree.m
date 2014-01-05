%% Parameters.
d = 9;
percentage = 1;
stoppingPure = true;
stoppingNumSamples = 2;
numTrees = 5;
maxDepth = 10;
validDepth = [1,2,5,10,12,15];

accuracies = zeros(3,maxDepth);
trainTimes = zeros(3,maxDepth);
testTimes = zeros(3,maxDepth);

startAccuraciesString = 'Evaluation_Forests/All_three/accuracy';
matEnd = '.mat';

%% Compare gini, entropy and misclassification rate.
try
    for i = 1:maxDepth
        maxHeight = i;
        
        forest = Forest(numTrees,percentage,d,'gini','p',stoppingPure,'d',maxHeight,'s',stoppingNumSamples);
        tic
        forest = forest.train(train_data,train_labels);
        Ttrain=toc;
        
        numDataPoints = size(valid_data,1);
        correct = 0;
        tic
        for j=1:numDataPoints
            classification = forest.classify(valid_data(j,:));
            if strcmp(classification,valid_labels{j})
                correct = correct + 1;
            end
        end
        Ttest=toc;
        accuracy = correct/numDataPoints;
        
        accuracies(1,i) = accuracy;
        trainTimes(1,i) = Ttrain;
        testTimes(1,i) = Ttest;
        
        saveString = strcat(startAccuraciesString,'_',num2str(i), ...
            '_forest_gini',matEnd);
        save(saveString,'accuracy','Ttrain','Ttest','-v7.3');
        
        
        %%%%%
%         clear bT;
%         bT = BinaryTree('entropy','p',true,'d',maxHeight,'s',2);
%         tic
%         bT = bT.train(train_data,train_labels);
%         Ttrain=toc;
%         
%         numDataPoints = size(valid_data,1);
%         correct = 0;
%         tic
%         for j=1:numDataPoints
%             classification = bT.classify(valid_data(j,:));
%             if strcmp(classification,valid_labels{j})
%                 correct = correct + 1;
%             end
%         end
%         Ttest=toc;
%         accuracy = correct/numDataPoints;
%         
%         accuracies(2,i) = accuracy;
%         trainTimes(2,i) = Ttrain;
%         testTimes(2,i) = Ttest;
%         
%         saveString = strcat(startAccuraciesString,'_',num2str(i), ...
%             '_entropy',matEnd);
%         save(saveString,'accuracy','Ttrain','Ttest','-v7.3');
%         
%         
%         %%%%%
%         clear bT;
%         bT = BinaryTree('misclassRate','p',true,'d',maxHeight,'s',2);
%         tic
%         bT = bT.train(train_data,train_labels);
%         Ttrain=toc;
%         
%         numDataPoints = size(valid_data,1);
%         correct = 0;
%         tic
%         for j=1:numDataPoints
%             classification = bT.classify(valid_data(j,:));
%             if strcmp(classification,valid_labels{j})
%                 correct = correct + 1;
%             end
%         end
%         Ttest=toc;
%         accuracy = correct/numDataPoints;
%         
%         accuracies(3,i) = accuracy;
%         trainTimes(3,i) = Ttrain;
%         testTimes(3,i) = Ttest;
%         
%         saveString = strcat(startAccuraciesString,'_',num2str(i), ...
%             '_misclassRate',matEnd);
%         save(saveString,'accuracy','Ttrain','Ttest','-v7.3');
%         
%         
%         %%%%%
%         saveString = strcat(startAccuraciesString,'_',num2str(i), ...
%             '_all',matEnd);
%         save(saveString,'accuracies','trainTimes','testTimes','-v7.3');
    end
catch exc
    getReport(exc)
    saveString = strcat(startAccuraciesString,'_',num2str(i), ...
        '_all_catch',matEnd);
    save(saveString,'accuracies','trainTimes','testTimes','-v7.3');
end

saveString = strcat(startAccuraciesString,'_',num2str(i), ...
    '_all_final',matEnd);
save(saveString,'accuracies','trainTimes','testTimes','-v7.3');
