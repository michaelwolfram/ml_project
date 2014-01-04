bT = BinaryTree('gini','p',true,'d',5);
bT = bT.trainImpurityMeasure(train_data,train_labels);

% numDataPoints = 10;
numDataPoints = size(valid_data,1);


correct = 0;
for i=1:numDataPoints
    classification = bT.classify(valid_data(i,:));
    if strcmp(classification,valid_labels{i})
        correct = correct + 1;
    end
end

correct/numDataPoints