% Parameters.
stoppingPure = true;
stoppingNumSamples = 2;

d = 5;
percentage = 1.0;

impurityMeasure = 'gini';
maxNumTrees = 16;
validDepths = [6];

accuracies = zeros(maxNumTrees,length(validDepths));
trainTimes = zeros(maxNumTrees,length(validDepths));
testTimes = zeros(maxNumTrees,length(validDepths));

startAccuraciesString = 'Evaluation_Forests/Gini_only_All_Forest_Part_Michi/accuracy';
matEnd = '.mat';

try
    for i = 1:length(validDepths)
        % Select current maximum height of each tree.
        maxHeight = validDepths(i);
        forest = Forest(0,percentage,d,impurityMeasure,'p',stoppingPure,...
            'd',maxHeight,'s',stoppingNumSamples);
        
        for currNumTrees=1:maxNumTrees
            % Add new tree to forest.
            forest = forest.addTree();
            
            % Re-train forest.
            tic
            forest = forest.train(train_data,train_labels);
            Ttrain=toc
            
            if currNumTrees >= 14
                % Classify testing data.
                numDataPoints = size(valid_data,1);
                correct = 0;
                tic
                for j=1:numDataPoints
                    classification = forest.classify(valid_data(j,:));
                    if strcmp(classification,valid_labels{j})
                        correct = correct + 1;
                    end
                end
                Ttest=toc
                accuracy = correct/numDataPoints;
                
                accuracies(currNumTrees,i) = accuracy;
                trainTimes(currNumTrees,i) = Ttrain;
                testTimes(currNumTrees,i) = Ttest;
                
                saveString = strcat(startAccuraciesString,'_',impurityMeasure,...
                    '_',num2str(maxHeight),'_',num2str(currNumTrees),'_',matEnd);
                save(saveString,'accuracy','Ttrain','Ttest','-v7.3');
            else
                saveString = strcat(startAccuraciesString,'_',impurityMeasure,...
                    '_',num2str(maxHeight),'_',num2str(currNumTrees),'_',matEnd);
                save(saveString,'Ttrain','forest','-v7.3');
            end
        end
    end
catch exc
    getReport(exc)
    saveString = strcat(startAccuraciesString,'_',impurityMeasure,...
        '_',num2str(0),'_',num2str(currNumTrees),'_all_catch',matEnd);
    save(saveString,'accuracies','trainTimes','testTimes','-v7.3');
end

saveString = strcat(startAccuraciesString,'_',num2str(i), ...
    '_',num2str(0),'_',num2str(currNumTrees),'_all_final',matEnd);
save(saveString,'accuracies','trainTimes','testTimes','-v7.3');
