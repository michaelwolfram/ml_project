% Parameters.
stoppingPure = true;
stoppingNumSamples = 2;

d = 5;
percentage = 1.0;

impurityMeasure = 'gini';

accuracies = zeros(18,1);
testTimes = zeros(18,1);

startAccuraciesString = 'accuracies';
matEnd = '.mat';

numDataPoints = size(valid_data,1);

% %% 1
% % Classify testing data.
% correct = 0;
% tic
% for j=1:numDataPoints
%     classification = forest_1.classify(valid_data(j,:));%%%%%%%%%%%%%%%
%     if strcmp(classification,valid_labels{j})
%         correct = correct + 1;
%     end
% end
% Ttest=toc
% accuracy = correct/numDataPoints;
% 
% accuracies(1) = accuracy;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% testTimes(1) = Ttest;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% saveString = strcat(startAccuraciesString,'_',impurityMeasure,...
%     '_',num2str(6),'_',num2str(1),'_',matEnd);%%%%%%%%%%%%%%%%%%%%%%%%%
% save(saveString,'accuracy','Ttest','-v7.3');
% 
% %% 2
% % Classify testing data.
% correct = 0;
% tic
% for j=1:numDataPoints
%     classification = forest_2.classify(valid_data(j,:));%%%%%%%%%%%%%%%
%     if strcmp(classification,valid_labels{j})
%         correct = correct + 1;
%     end
% end
% Ttest=toc
% accuracy = correct/numDataPoints;
% 
% accuracies(2) = accuracy;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% testTimes(2) = Ttest;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% saveString = strcat(startAccuraciesString,'_',impurityMeasure,...
%     '_',num2str(6),'_',num2str(2),'_',matEnd);%%%%%%%%%%%%%%%%%%%%%%%%%
% save(saveString,'accuracy','Ttest','-v7.3');
% 
% %% 3
% % Classify testing data.
% correct = 0;
% tic
% for j=1:numDataPoints
%     classification = forest_3.classify(valid_data(j,:));%%%%%%%%%%%%%%%
%     if strcmp(classification,valid_labels{j})
%         correct = correct + 1;
%     end
% end
% Ttest=toc
% accuracy = correct/numDataPoints;
% 
% accuracies(3) = accuracy;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% testTimes(3) = Ttest;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% saveString = strcat(startAccuraciesString,'_',impurityMeasure,...
%     '_',num2str(6),'_',num2str(3),'_',matEnd);%%%%%%%%%%%%%%%%%%%%%%%%%
% save(saveString,'accuracy','Ttest','-v7.3');
% 
% %% 4
% % Classify testing data.
% correct = 0;
% tic
% for j=1:numDataPoints
%     classification = forest_4.classify(valid_data(j,:));%%%%%%%%%%%%%%%
%     if strcmp(classification,valid_labels{j})
%         correct = correct + 1;
%     end
% end
% Ttest=toc
% accuracy = correct/numDataPoints;
% 
% accuracies(4) = accuracy;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% testTimes(4) = Ttest;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% saveString = strcat(startAccuraciesString,'_',impurityMeasure,...
%     '_',num2str(6),'_',num2str(4),'_',matEnd);%%%%%%%%%%%%%%%%%%%%%%%%%
% save(saveString,'accuracy','Ttest','-v7.3');
% 
% %% 5
% % Classify testing data.
% correct = 0;
% tic
% for j=1:numDataPoints
%     classification = forest_5.classify(valid_data(j,:));%%%%%%%%%%%%%%%
%     if strcmp(classification,valid_labels{j})
%         correct = correct + 1;
%     end
% end
% Ttest=toc
% accuracy = correct/numDataPoints;
% 
% accuracies(5) = accuracy;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% testTimes(5) = Ttest;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% saveString = strcat(startAccuraciesString,'_',impurityMeasure,...
%     '_',num2str(6),'_',num2str(5),'_',matEnd);%%%%%%%%%%%%%%%%%%%%%%%%%
% save(saveString,'accuracy','Ttest','-v7.3');
% 
% %% 6
% % Classify testing data.
% correct = 0;
% tic
% for j=1:numDataPoints
%     classification = forest_6.classify(valid_data(j,:));%%%%%%%%%%%%%%%
%     if strcmp(classification,valid_labels{j})
%         correct = correct + 1;
%     end
% end
% Ttest=toc
% accuracy = correct/numDataPoints;
% 
% accuracies(6) = accuracy;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% testTimes(6) = Ttest;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% saveString = strcat(startAccuraciesString,'_',impurityMeasure,...
%     '_',num2str(6),'_',num2str(6),'_',matEnd);%%%%%%%%%%%%%%%%%%%%%%%%%
% save(saveString,'accuracy','Ttest','-v7.3');
% 
% %% 7
% % Classify testing data.
% correct = 0;
% tic
% for j=1:numDataPoints
%     classification = forest_7.classify(valid_data(j,:));%%%%%%%%%%%%%%%
%     if strcmp(classification,valid_labels{j})
%         correct = correct + 1;
%     end
% end
% Ttest=toc
% accuracy = correct/numDataPoints;
% 
% accuracies(7) = accuracy;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% testTimes(7) = Ttest;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% saveString = strcat(startAccuraciesString,'_',impurityMeasure,...
%     '_',num2str(6),'_',num2str(7),'_',matEnd);%%%%%%%%%%%%%%%%%%%%%%%%%
% save(saveString,'accuracy','Ttest','-v7.3');
% 
% %% 8
% % Classify testing data.
% correct = 0;
% tic
% for j=1:numDataPoints
%     classification = forest_8.classify(valid_data(j,:));%%%%%%%%%%%%%%%
%     if strcmp(classification,valid_labels{j})
%         correct = correct + 1;
%     end
% end
% Ttest=toc
% accuracy = correct/numDataPoints;
% 
% accuracies(8) = accuracy;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% testTimes(8) = Ttest;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% saveString = strcat(startAccuraciesString,'_',impurityMeasure,...
%     '_',num2str(6),'_',num2str(8),'_',matEnd);%%%%%%%%%%%%%%%%%%%%%%%%%
% save(saveString,'accuracy','Ttest','-v7.3');
% 
% %% 9
% % Classify testing data.
% correct = 0;
% tic
% for j=1:numDataPoints
%     classification = forest_9.classify(valid_data(j,:));%%%%%%%%%%%%%%%
%     if strcmp(classification,valid_labels{j})
%         correct = correct + 1;
%     end
% end
% Ttest=toc
% accuracy = correct/numDataPoints;
% 
% accuracies(9) = accuracy;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% testTimes(9) = Ttest;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% saveString = strcat(startAccuraciesString,'_',impurityMeasure,...
%     '_',num2str(6),'_',num2str(9),'_',matEnd);%%%%%%%%%%%%%%%%%%%%%%%%%
% save(saveString,'accuracy','Ttest','-v7.3');
% 
% %% 10
% % Classify testing data.
% correct = 0;
% tic
% for j=1:numDataPoints
%     classification = forest_10.classify(valid_data(j,:));%%%%%%%%%%%%%%%
%     if strcmp(classification,valid_labels{j})
%         correct = correct + 1;
%     end
% end
% Ttest=toc
% accuracy = correct/numDataPoints;
% 
% accuracies(10) = accuracy;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% testTimes(10) = Ttest;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% saveString = strcat(startAccuraciesString,'_',impurityMeasure,...
%     '_',num2str(6),'_',num2str(10),'_',matEnd);%%%%%%%%%%%%%%%%%%%%%%%%%
% save(saveString,'accuracy','Ttest','-v7.3');
% 
% %% 11
% % Classify testing data.
% correct = 0;
% tic
% for j=1:numDataPoints
%     classification = forest_11.classify(valid_data(j,:));%%%%%%%%%%%%%%%
%     if strcmp(classification,valid_labels{j})
%         correct = correct + 1;
%     end
% end
% Ttest=toc
% accuracy = correct/numDataPoints;
% 
% accuracies(11) = accuracy;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% testTimes(11) = Ttest;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% saveString = strcat(startAccuraciesString,'_',impurityMeasure,...
%     '_',num2str(6),'_',num2str(11),'_',matEnd);%%%%%%%%%%%%%%%%%%%%%%%%%
% save(saveString,'accuracy','Ttest','-v7.3');
% 
% %% 12
% % Classify testing data.
% correct = 0;
% tic
% for j=1:numDataPoints
%     classification = forest_12.classify(valid_data(j,:));%%%%%%%%%%%%%%%
%     if strcmp(classification,valid_labels{j})
%         correct = correct + 1;
%     end
% end
% Ttest=toc
% accuracy = correct/numDataPoints;
% 
% accuracies(12) = accuracy;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% testTimes(12) = Ttest;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% saveString = strcat(startAccuraciesString,'_',impurityMeasure,...
%     '_',num2str(6),'_',num2str(12),'_',matEnd);%%%%%%%%%%%%%%%%%%%%%%%%%
% save(saveString,'accuracy','Ttest','-v7.3');
% 
% %% 13
% % Classify testing data.
% correct = 0;
% tic
% for j=1:numDataPoints
%     classification = forest_13.classify(valid_data(j,:));%%%%%%%%%%%%%%%
%     if strcmp(classification,valid_labels{j})
%         correct = correct + 1;
%     end
% end
% Ttest=toc
% accuracy = correct/numDataPoints;
% 
% accuracies(13) = accuracy;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% testTimes(13) = Ttest;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% saveString = strcat(startAccuraciesString,'_',impurityMeasure,...
%     '_',num2str(6),'_',num2str(13),'_',matEnd);%%%%%%%%%%%%%%%%%%%%%%%%%
% save(saveString,'accuracy','Ttest','-v7.3');
% 
% %% 14
% % Classify testing data.
% correct = 0;
% tic
% for j=1:numDataPoints
%     classification = forest_14.classify(valid_data(j,:));%%%%%%%%%%%%%%%
%     if strcmp(classification,valid_labels{j})
%         correct = correct + 1;
%     end
% end
% Ttest=toc
% accuracy = correct/numDataPoints;
% 
% accuracies(14) = accuracy;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% testTimes(14) = Ttest;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% saveString = strcat(startAccuraciesString,'_',impurityMeasure,...
%     '_',num2str(6),'_',num2str(14),'_',matEnd);%%%%%%%%%%%%%%%%%%%%%%%%%
% save(saveString,'accuracy','Ttest','-v7.3');

%% 15
% Classify testing data.
correct = 0;
tic
for j=1:numDataPoints
    classification = forest_15.classify(valid_data(j,:));%%%%%%%%%%%%%%%
    if strcmp(classification,valid_labels{j})
        correct = correct + 1;
    end
end
Ttest=toc
accuracy = correct/numDataPoints;

accuracies(15) = accuracy;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
testTimes(15) = Ttest;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

saveString = strcat(startAccuraciesString,'_',impurityMeasure,...
    '_',num2str(6),'_',num2str(15),'_',matEnd);%%%%%%%%%%%%%%%%%%%%%%%%%
save(saveString,'accuracy','Ttest','-v7.3');

%% 16
% Classify testing data.
correct = 0;
tic
for j=1:numDataPoints
    classification = forest_16.classify(valid_data(j,:));%%%%%%%%%%%%%%%
    if strcmp(classification,valid_labels{j})
        correct = correct + 1;
    end
end
Ttest=toc
accuracy = correct/numDataPoints;

accuracies(16) = accuracy;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
testTimes(16) = Ttest;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

saveString = strcat(startAccuraciesString,'_',impurityMeasure,...
    '_',num2str(6),'_',num2str(16),'_',matEnd);%%%%%%%%%%%%%%%%%%%%%%%%%
save(saveString,'accuracy','Ttest','-v7.3');

%% 17
% Classify testing data.
correct = 0;
tic
for j=1:numDataPoints
    classification = forest_17.classify(valid_data(j,:));%%%%%%%%%%%%%%%
    if strcmp(classification,valid_labels{j})
        correct = correct + 1;
    end
end
Ttest=toc
accuracy = correct/numDataPoints;

accuracies(17) = accuracy;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
testTimes(17) = Ttest;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

saveString = strcat(startAccuraciesString,'_',impurityMeasure,...
    '_',num2str(6),'_',num2str(17),'_',matEnd);%%%%%%%%%%%%%%%%%%%%%%%%%
save(saveString,'accuracy','Ttest','-v7.3');

%% 18
% Classify testing data.
correct = 0;
tic
for j=1:numDataPoints
    classification = forest_18.classify(valid_data(j,:));%%%%%%%%%%%%%%%
    if strcmp(classification,valid_labels{j})
        correct = correct + 1;
    end
end
Ttest=toc
accuracy = correct/numDataPoints;

accuracies(18) = accuracy;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
testTimes(18) = Ttest;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

saveString = strcat(startAccuraciesString,'_',impurityMeasure,...
    '_',num2str(6),'_',num2str(18),'_',matEnd);%%%%%%%%%%%%%%%%%%%%%%%%%
save(saveString,'accuracy','Ttest','-v7.3');


%% Save everything.
saveString = strcat(startAccuraciesString,'_',impurityMeasure, ...
    '_',num2str(6),'_all_final',matEnd);
save(saveString,'accuracies','testTimes','-v7.3');
