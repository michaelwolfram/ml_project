%% Create small tree cell.
smallerForests={1,18};

for i=1:18
    smallerForests{i} = forest;
    smallerForests{i}.numTrees = i;
    smallerForests{i}.trainedTrees = ones(1,i);
    smallerForests{i}.trees = forest.trees(1:i);
end