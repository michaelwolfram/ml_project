startAccuraciesString = 'Evaluation_Forests/Gini_only/accuracy';
matEnd = '.mat';

%% Section for final plots.
% Do not wonder about the name of the variable.
% It was quite late that day. ;-)
saveString = strcat('Evaluation_Forests/Gini_only/accuracies_gini_final_15_20',matEnd);
load(saveString);

validDepths = [2,4,6,8,10,12,15];
numTrees = 1:1:20;

% Plot heatmap.
figure;
hold on;
imagesc(accuracies_all(2:8,:));
colorbar;
title('Heatmap of accuracies of Forests [%]');
xlabel('Number of Trees');
ylabel('Depth of Trees');
axis([0.5 20.5 0.5 8.5]);
axis('image');
set(gca,'XTick',1:length(numTrees));
set(gca,'XTickLabel',numTrees);
set(gca,'YTick',1:length(validDepths));
set(gca,'YTickLabel',validDepths);
hold off;

% Plot training time.
% figure;
% hold on;
% colors=['y','m','c','r','g','b','k','b'];
% for i=1:size(timesTrain_all,1)
%     plot(timesTrain_all(i,:),colors(i));
% end
% title('Training time depending on the number of Trees');
% xlabel('Number of Trees');
% ylabel('Time for training [s]');
% hold off;

% validDepths = [1,2,4,6,8,10,12,15];
% meanTrainTimes = mean(timesTrain_all,2)';
% figure;
% hold on;
% % colors=['y','m','c','r','g','b','k','b'];
% % for i=1:size(timesTest_all,1)
% %     plot(timesTest_all(i,:),colors(i));
% % end
% plot(validDepths,meanTrainTimes);
% set(gca,'XTick',0:15);
% title('Mean training time of a Tree depending on its depth');
% xlabel('Depth of Tree');
% ylabel('Time for testing [s]');
% hold off;

% Plot testing time.
figure;
hold on;
colors=['y','m','c','r','g','b','k','b'];
for i=1:size(timesTest_all,1)
    plot(timesTest_all(i,:),colors(i));
end
title('Testing time depending on the number of Trees');
xlabel('Number of Trees');
ylabel('Time for testing [s]');
hold off;

% meanTestTimes = mean(timesTest_all,2)';
% figure;
% hold on;
% plot(validDepths,meanTestTimes);
% set(gca,'XTick',0:15);
% title('Mean testing time of a Tree depending on its depth');
% xlabel('Depth of Tree');
% ylabel('Time for testing [s]');
% hold off;

%% Section for testing some plots with already generated data.
% DO NOT USE FOR FINAL PLOTS.
accuracies_1 = zeros(1,20);
timesTrain_1 = zeros(1,20);
timesTest_1 = zeros(1,20);

for i=1:20
    saveString = strcat(startAccuraciesString,'_','gini',...
        '_',num2str(1),'_',num2str(i),'_',matEnd);
    load(saveString);
    accuracies_1(i) = accuracy;
    timesTrain_1(i) = Ttrain;
    timesTest_1(i) = Ttest;
end

accuracies_2 = zeros(1,20);
timesTrain_2 = zeros(1,20);
timesTest_2 = zeros(1,20);

for i=1:20
    saveString = strcat(startAccuraciesString,'_','gini',...
        '_',num2str(2),'_',num2str(i),'_',matEnd);
    load(saveString);
    accuracies_2(i) = accuracy;
    timesTrain_2(i) = Ttrain;
    timesTest_2(i) = Ttest;
end

accuracies_4 = zeros(1,20);
timesTrain_4 = zeros(1,20);
timesTest_4 = zeros(1,20);

for i=1:20
    saveString = strcat(startAccuraciesString,'_','gini',...
        '_',num2str(4),'_',num2str(i),'_',matEnd);
    load(saveString);
    accuracies_4(i) = accuracy;
    timesTrain_4(i) = Ttrain;
    timesTest_4(i) = Ttest;
end

accuracies_6 = zeros(1,20);
timesTrain_6 = zeros(1,20);
timesTest_6 = zeros(1,20);

for i=1:20
    saveString = strcat(startAccuraciesString,'_','gini',...
        '_',num2str(6),'_',num2str(i),'_',matEnd);
    load(saveString);
    accuracies_6(i) = accuracy;
    timesTrain_6(i) = Ttrain;
    timesTest_6(i) = Ttest;
end

accuracies_8 = zeros(1,20);
timesTrain_8 = zeros(1,20);
timesTest_8 = zeros(1,20);

for i=1:20
    saveString = strcat(startAccuraciesString,'_','gini',...
        '_',num2str(8),'_',num2str(i),'_',matEnd);
    load(saveString);
    accuracies_8(i) = accuracy;
    timesTrain_8(i) = Ttrain;
    timesTest_8(i) = Ttest;
end

accuracies_10 = zeros(1,20);
timesTrain_10 = zeros(1,20);
timesTest_10 = zeros(1,20);

for i=1:20
    saveString = strcat(startAccuraciesString,'_','gini',...
        '_',num2str(10),'_',num2str(i),'_',matEnd);
    load(saveString);
    accuracies_10(i) = accuracy;
    timesTrain_10(i) = Ttrain;
    timesTest_10(i) = Ttest;
end

accuracies_12 = zeros(1,20);
timesTrain_12 = zeros(1,20);
timesTest_12 = zeros(1,20);

for i=1:20
    saveString = strcat(startAccuraciesString,'_','gini',...
        '_',num2str(12),'_',num2str(i),'_',matEnd);
    load(saveString);
    accuracies_12(i) = accuracy;
    timesTrain_12(i) = Ttrain;
    timesTest_12(i) = Ttest;
end

accuracies_15 = zeros(1,20);
timesTrain_15 = zeros(1,20);
timesTest_15 = zeros(1,20);

for i=1:20
    saveString = strcat(startAccuraciesString,'_','gini',...
        '_',num2str(15),'_',num2str(i),'_',matEnd);
    load(saveString);
    accuracies_15(i) = accuracy;
    timesTrain_15(i) = Ttrain;
    timesTest_15(i) = Ttest;
end

accuracies_all =...
    [accuracies_1;accuracies_2;accuracies_4;accuracies_6;accuracies_8;accuracies_10;accuracies_12;accuracies_15];
timesTrain_all =...
    [timesTrain_1;timesTrain_2;timesTrain_4;timesTrain_6;timesTrain_8;timesTrain_10;timesTrain_12;timesTrain_15];
timesTest_all =...
    [timesTest_1;timesTest_2;timesTest_4;timesTest_6;timesTest_8;timesTest_10;timesTest_12;timesTest_15];

% save('Evaluation_Forests/Gini_only/accuracies_gini_final_15_20','accuracies_all','timesTrain_all','timesTest_all','-v7.3');

validDepths = [1,2,4,6,8,10,12,15];
numTrees = 1:1:20;

figure;
hold on;
imagesc(accuracies_all);
colorbar;
title('Heatmap of accuracies of forests [%]');
xlabel('Number of trees');
ylabel('Depth of trees');
axis([0.5 20.5 0.5 8.5]);
axis('image');
set(gca,'XTick',1:length(numTrees));
set(gca,'XTickLabel',numTrees);
set(gca,'YTick',1:length(validDepths));
set(gca,'YTickLabel',validDepths);
hold off;

figure;
hold on;
colors=['y','m','c','r','g','b','k','b'];
for i=1:size(timesTrain_all,1)
    plot(timesTrain_all(i,:),colors(i));
end
title('Training time according to the number of trees');
xlabel('Number of trees');
ylabel('Time for training [s]');
hold off;

figure;
hold on;
colors=['y','m','c','r','g','b','k','b'];
for i=1:size(timesTest_all,1)
    plot(timesTest_all(i,:),colors(i));
end
title('Testing time according to the number of trees');
xlabel('Number of trees');
ylabel('Time for testing [s]');
hold off;