maxDepth = 10;

accuracies = zeros(3,maxDepth);

startAccuraciesString = 'Evaluation/Accuracies/accuracy';
matEnd = '.mat';

try
    for i = 1:maxDepth
        maxHeight = i;
        
        bT = BinaryTree('gini','p',true,'d',maxHeight);
        bT = bT.trainImpurityMeasure(train_data,train_labels);
        
        numDataPoints = size(valid_data,1);
        correct = 0;
        for j=1:numDataPoints
            classification = bT.classify(valid_data(j,:));
            if strcmp(classification,valid_labels{j})
                correct = correct + 1;
            end
        end
        accuracy = correct/numDataPoints;
        accuracies(1,i) = accuracy;
        
        saveString = strcat(startAccuraciesString,'_',num2str(i), ...
            '_gini',matEnd);
        save(saveString,'accuracy','-v7.3');
        
        
        %%%%%
        clear bT;
        bT = BinaryTree('entropy','p',true,'d',maxHeight);
        bT = bT.trainImpurityMeasure(train_data,train_labels);
        
        numDataPoints = size(valid_data,1);
        correct = 0;
        for j=1:numDataPoints
            classification = bT.classify(valid_data(j,:));
            if strcmp(classification,valid_labels{j})
                correct = correct + 1;
            end
        end
        accuracy = correct/numDataPoints;
        accuracies(2,i) = accuracy;
        
        saveString = strcat(startAccuraciesString,'_',num2str(i), ...
            '_entropy',matEnd);
        save(saveString,'accuracy','-v7.3');
        
        
        %%%%%
        clear bT;
        bT = BinaryTree('misclassRate','p',true,'d',maxHeight);
        bT = bT.trainImpurityMeasure(train_data,train_labels);
        
        numDataPoints = size(valid_data,1);
        correct = 0;
        for j=1:numDataPoints
            classification = bT.classify(valid_data(j,:));
            if strcmp(classification,valid_labels{j})
                correct = correct + 1;
            end
        end
        accuracy = correct/numDataPoints;
        accuracies(3,i) = accuracy;
        
        saveString = strcat(startAccuraciesString,'_',num2str(i), ...
            '_misclassRate',matEnd);
        save(saveString,'accuracy','-v7.3');
        
        
        %%%%%
        saveString = strcat(startAccuraciesString,'_',num2str(i), ...
            '_all',matEnd);
        save(saveString,'accuracies','-v7.3');
    end
catch
    saveString = strcat(startAccuraciesString,'_',num2str(i), ...
        '_all_catch',matEnd);
    save(saveString,'accuracies','-v7.3');
end

saveString = strcat(startAccuraciesString,'_',num2str(i), ...
    '_all_final',matEnd);
save(saveString,'accuracies','-v7.3');





