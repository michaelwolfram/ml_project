startAccuraciesString = 'Evaluation_Forests/Gini_only_all/';
matEnd = '.mat';

%% Section for final plots.
% Do not wonder about the name of the variable.
% It was quite late that day. ;-)
saveString = strcat('Evaluation_Forests/Gini_only_all/all_data_inside',matEnd);
load(saveString);

validDepths = [6];
numTrees = 1:1:28;

% Plot heatmap.
% figure;
% hold on;
% imagesc(accuracies_all(1,:));
% colorbar;
% title('Heatmap of accuracies of Forests [%]');
% xlabel('Number of Trees');
% ylabel('Depth of Trees');
% axis([0.5 20.5 0.5 8.5]);
% axis('image');
% set(gca,'XTick',1:length(numTrees));
% set(gca,'XTickLabel',numTrees);
% set(gca,'YTick',1:length(validDepths));
% set(gca,'YTickLabel',validDepths);
% hold off;

% figure;
% hold on;
% colors=['b','m','c','r','g','b','k','b'];
% for i=1:size(accuracies_all,1)
%     plot(accuracies_all(i,:),colors(i));
% end
% title('Accuracies of Forests depending on the number of Trees');
% xlabel('Number of Trees');
% ylabel('Accuracy of classification [%]');
% hold off;

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

validDepths = [1,2,4,6,8,10,12,15];
meanTrainTimes = mean(timesTrain_all,2)'
figure;
hold on;
% colors=['y','m','c','r','g','b','k','b'];
% for i=1:size(timesTest_all,1)
%     plot(timesTest_all(i,:),colors(i));
% end
plot(validDepths,meanTrainTimes);
set(gca,'XTick',0:15);
title('Mean training time of a Tree depending on its depth');
xlabel('Depth of Tree');
ylabel('Time for training [s]');
hold off;

% Plot testing time.
figure;
hold on;
colors=['b','m','c','r','g','b','k','b'];
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
