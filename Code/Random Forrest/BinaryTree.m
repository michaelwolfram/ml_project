classdef BinaryTree
    %BINARYTREE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % All possible classes.
        classes;
        
        % Used impurity measure of this tree.
        impurityMeasure;
        
        % Parameters for all stopping heuristics:
        %   * 'p' - distribution in branch is pure: [true|false]
        %   * 'd' - maximum depth reached:          0=not used, 1..=used
        %   * 's' - number of samples in each branch below certain
        %           threshold t_n:                  0=not used, 0.x..=used
        %   * 'b' - benefit of splitting is below certain threshold
        %           cost(D) - [pi_L*cost(D_L)+pi_R*cost(D_R)] < t_{delta}:
        %                                           0=not used, 0.x..=used
        stoppingParams;
        
        % Properties of every node of the tree.
        % (      node 1     | ... |     node n      )
        %
        %  -----------------------------------------
        % | feature index 1 | ... | feature index n |
        % |-----------------------------------------|
        % |   threshold 1   | ... |   threshold n   |
        % |-----------------------------------------|
        % |     isLeaf 1    | ... |    isLeaf n     |
        % |-----------------------------------------|
        % |   treeLayer 1   | ... |   treeLayer n   |
        %  -----------------------------------------
        %
        %                      1
        %                     / \
        %                    2   3
        %                   / \ / \
        %                 ...  ... n
        allNodesList;
        
        % Cell array containing all leafs and their necessary properties.
        leafsList;
        
        % Adjacency matrix containing the actual structure of the tree.
        adjacencyMatrix;
    end
    
    methods
        % Constructor.
        function obj=BinaryTree(impurityMeasure, varargin)
            if strcmp(impurityMeasure,'gini') ||...
                    strcmp(impurityMeasure,'entropy') ||...
                    strcmp(impurityMeasure,'misclassRate') ||...
                    strcmp(impurityMeasure,'random')
                obj.impurityMeasure = impurityMeasure;
            else
                error(['This is not a valid method for the'...
                    ' measurement of impurity of a given'...
                    ' distribution. Please provide either'...
                    ' ''gini'', ''entropy'', ''misclassRate'','...
                    ' ''random''.']);
            end
            
            argSize = size(varargin,2);
            if argSize==0
                error('Specify at least one stopping heuristic.');
            elseif mod(argSize,2)==1
                obj.printVararginErrorMsg();
            end
            obj.stoppingParams = struct('pure','false','depth',0,...
                'numSamples',0,'benefit',0);
            for i=1:(argSize/2)
                j = i*2-1;
                switch varargin{j}
                    case 'p'
                        obj.stoppingParams.pure = varargin{j+1};
                    case 'd'
                        obj.stoppingParams.depth = varargin{j+1};
                    case 's'
                        obj.stoppingParams.numSamples = varargin{j+1};
                    case 'b'
                        obj.stoppingParams.benefit = varargin{j+1};
                    otherwise
                        obj.printVararginErrorMsg();
                end
            end
        end
        
        % Train a tree with some training data by randomly selecting
        % the features as well as the thresholds at each decision node.
        function obj=trainRandom(obj, train_data, train_labels)
            % When initializing a tree a impurity measure method must be
            % specified. Therefore, the consistency of the used method
            % should be checked here.
            if ~strcmp(obj.impurityMeasure,'random')
                error('This tree is supposed to by trained with the random method.');
            end
            
            obj.classes = unique(train_labels);
            
        end
        
        % Train a tree with some training data using some impurity measure
        % like the Gini index.
        function obj=trainImpurityMeasure(obj, train_data, train_labels)
            % When initializing a tree a impurity measure method must be
            % specified. Therefore, the consistency of the used method
            % should be checked here.
            if strcmp(obj.impurityMeasure,'random')
                error('This tree is supposed to by trained with some kind of impurity measure like the Gini index.');
            end
            
            obj.classes = unique(train_labels);
            
            % In the list of splitted training data i specifies the
            % currently treated node and the one to be treated next,
            % respectively.
            i = 1;
            % In the list of splitted training data j specifies the index
            % of the most recently added node. Thus, the number of a new
            % node to be added is j+1.
            j = 1;
            
            treeHeight = 1;
            numLeafs = 0;
            abort = false;
            
            % Initialize splitted training data with all training data and
            % labels.
            obj.splittedTrainingData{1,1} = train_data;
            obj.splittedTrainingData{2,1} = train_labels;
            classSize = size(obj.classes,1);
            distribution = zeros(classSize,1);
            for i=1:classSize
                distribution(i) = numel(find(strcmp(train_labels,obj.classes{i})));
            end
            obj.splittedTrainingData{3,1} = distribution;
            
            % Initialize list of all nodes with root node.
            obj.allNodesList = [0; 0; false; treeHeight];
            
            % Initialize adjacency matrix.
            obj.adjacencyMatriy = sparse(1,1);
            
            while ~abort
                % Get distribution of the current node.
                currDistribution = obj.splittedTrainingData{3,i};
                
                %%%% Stopping criterias to be tested before actually
                %%%% splitting the node.
                
                % Check if the distribution of the current node is pure.
                %
                % Check if the maximum depth of the tree is reached via
                % this node.
                %
                % Check if the number of data samples in this node is below
                % a given threshold t_n.
                %
                % If one of these tests return true, mark this node as leaf
                % and do some other stuff for saving a new leaf.
                markAsLeaf = false;
                if (obj.stoppingParams.pure==true...
                        && max(currDistribution)==sum(currDistribution)) ||...
                        (obj.stoppingParams.depth~=0 ...
                        && obj.allNodesList(4,currNode)>=obj.stoppingParams.depth) ||...
                        (obj.stoppingParams.numSamples~=0 ...
                        && sum(currDistribution)<obj.stoppingParams.numSamples)
                    markAsLeaf = true;
                end
                
                %%%% Stopping criterias to be tested after actually
                %%%% splitting the node.
                
                % Check if the benefit of splitting is below a given
                % threshold t_{delta}.
                % If yes, mark this node as leaf and do some other
                % stuff for saving a new leaf.
                currData = obj.splittedTrainingData{3,i};
                currLabels = obj.splittedTrainingData{3,i};
                [featureDimension,featureValue,splitCosts] =...
                    obj.findBestSplit(currData,currLabels);
                
                if ~markAsLeaf
                    if (obj.stoppingParams.benefit~=0 ...
                            && (obj.costs(currDistribution)-splitCosts)<obj.stoppingParams.benefit)
                        markAsLeaf = true;
                    end
                end
                
                if markAsLeaf
                    % Mark node as leaf.
                    obj.allNodesList(3,i) = true;
                    
                    % Create new entry in leafsList
                    numLeafs = numLeafs + 1;
                    obj.leafsList{1,numLeafs} = i;
                    obj.leafsList{2,numLeafs} =...
                        obj.classes{...
                        find(currDistribution==max(currDistribution),1)};
                    obj.leafsList{3,numLeafs} = currDistribution;
                    
                    % Delete entry in splittedTrainingData
                    obj.splittedTrainingData{1,i} = [];
                    obj.splittedTrainingData{2,i} = [];
                    
                    % Continue with next node.
                    i = i + 1;
                    if i>j
                        abort = true;
                    end
                else
                    % Actually splitting the node.
                    
                    % Update entry of current node in list of all nodes.
                    obj.allNodesList(1,i) = featureDimension;
                    obj.allNodesList(2,i) = featureValue;
                    
                    [left_data,left_labels,left_distribution,...
                        right_data,right_labels,right_distribution] =...
                        splitTreeData(featureDimension,featureValue,currData,currLabels);
                    % Add both children to splitted training data.
                    obj.splittedTrainingData{1,j+1} = left_data;
                    obj.splittedTrainingData{2,j+1} = left_labels;
                    obj.splittedTrainingData{3,j+1} = left_distribution;
                    obj.splittedTrainingData{1,j+2} = right_data;
                    obj.splittedTrainingData{2,j+2} = right_labels;
                    obj.splittedTrainingData{3,j+2} = right_distribution;
                    
                    % Add both children to the list of all nodes.
                    currHeight = obj.allNodesList(4,i);
                    if currHeight == treeHeight
                        treeHeight = treeHeight + 1;
                    end
                    newEntry = [0; 0; false; (currHeight + 1)];
                    obj.allNodesList = [obj.allNodesList, newEntry, newEntry];
                    
                    % Update the adjacency matrix.
                    currMatSize = size(obj.adjacencyMatrix);
                    obj.adjacencyMatrix = [obj.adjacencyMatrix,zeros(currMatSize(1),1),zeros(currMatSize(1),1)];
                    obj.adjacencyMatrix = [obj.adjacencyMatrix;zeros(1,currMatSize(2));zeros(1,currMatSize(2))];
                    obj.adjacencyMatrix(i,currMatSize+1) = 1;
                    obj.adjacencyMatrix(i,currMatSize+2) = 1;
                    
                    % Continue with next node but don't forget to increment
                    % j by 2 so that it still points to the most recently
                    % added node.
                    i = i + 1;
                    j = j + 2;
                end
            end
        end
        
        % Classify a new data point given its feature vector.
        function [classification,classCertainty] = classify(obj, featureVector)
            classification = '';
            
            % Select root at start node.
            currNode = 1;
            while isempty(classification)
                if obj.allNodesList(3,currNode) == true
                    % This node is a leaf. Classify and exit.
                    index = find(obj.leafsList{1,:}==currNode,1);
                    classification = obj.leafsList{2,index};
                    distribution = obj.leafsList{3,index};
                    classCertainty = max(distribution) / sum(distribution);
                else
                    % This node is a inner node. Select correct child.
                    [~, children] = find(obj.adjacencyMatrix(currNode,:)==1,2);
                    if featureVector(obj.allNodesList(1,currNode)) <= obj.allNodesList(2,currNode)
                        % Select left child.
                        currNode = children(1);
                    else
                        % Select right child.
                        currNode = children(2);
                    end
                end
            end
        end
        
    end
    
    methods (Access=private)
        function giniValue=gini(obj, currDistribution)
            partSize = size(currDistribution);
            if partSize(1)~=1 || partSize(2)~=size(obj.classes,2)
                error(['Size of currPartition does not match number of'...
                    'possible classes.']);
            end
            s = sum(currDistribution);
            if s == 0
                error(['This should not have happened. Please contact'...
                    'your system administrator.']);
            else
                pi = currDistribution / s;
                giniValue = 1.0 - sum(pi.*pi);
            end
        end
        
        function entropyValue=entropy(obj, currDistribution)
            partSize = size(currDistribution);
            if partSize(1)~=1 || partSize(2)~=size(obj.classes,2)
                error(['Size of currPartition does not match number of'...
                    'possible classes.']);
            end
            s = sum(currDistribution);
            if s == 0
                error(['This should not have happened. Please contact'...
                    'your system administrator.']);
            else
                pi = currDistribution / s;
                entropyValue = -sum(pi.*log(pi));
            end
        end
        
        function misclassRateValue=misclassRate(obj,currDistribution)
            partSize = size(currDistribution);
            if partSize(1)~=1 || partSize(2)~=size(obj.classes,2)
                error(['Size of currPartition does not match number of'...
                    'possible classes.']);
            end
            s = sum(currDistribution);
            if s == 0
                error(['This should not have happened. Please contact'...
                    'your system administrator.']);
            else
                misclassRateValue = (s-max(currDistribution)) / s;
            end
        end
        
        function costz = costs(obj, distribution)
            switch obj.impurityMeasure
                case 'gini'
                    costz = obj.gini(distribution);
                case 'entropy'
                    costz = obj.entropy(distribution);
                case 'misclassRate'
                    costz = obj.misclassRate(distribution);
                otherwise
                    error(['This is not a valid method for the'...
                        ' measurement of impurity of a given'...
                        ' distribution.']);
            end
        end
        
        function newCosts=calcNewCosts(obj,left,right)
            l = sum(left);
            r = sum(right);
            all = l + r;
            newCosts = (l*obj.costs(left) + r*obj.costs(right)) / all;
        end
        
        function [left,right]=splitTreePi(obj,featureDimension,featureValue,train_data,train_labels)
            classSize = size(obj.classes,1);
            left = zeros(classSize,1);
            right = zeros(classSize,1);
            value = train_data(featureValue,featureDimension);
            
            l = train_labels(train_data(:,featureDimension)<=value);
            r = train_labels(train_data(:,featureDimension)>value);
            for i=1:classSize
                left(i) = size(find(strcmp(l,obj.classes{i})),1);
                right(i) = size(find(strcmp(r,obj.classes{i})),1);
            end
        end
        
        function [featureDimension,featureValue,splitCosts]=findBestSplit(obj,train_data,train_labels)
            curr_i = 0;
            curr_j = 0;
            curr_costs = inf;
            for i=1:size(train_data,1)
                for j=1:size(train_data,2)
                    [left,right] = obj.splitTreePi(j,i,train_data,train_labels);
                    tmp = obj.calcNewCosts(left,right);
                    if tmp < curr_costs
                        curr_i = i;
                        curr_j = j;
                        curr_costs = tmp;
                    end
                end
            end
            featureDimension = curr_j;
            featureValue = curr_i;
            splitCosts = curr_costs;
        end
    end
    
    methods (Access=private, Static=true)
        function printVararginErrorMsg()
            error(['Please provide the stopping heuristics in pairs'...
                ' in the following way: <X,Y> where X is one of ''p'''...
                ' (pure branch), ''d''(maximum depth), ''s''(number of'...
                ' samples) or ''b''(benefit of splitting) and Y is'...
                ' [''true''|''false''], an integer value, a threshold'...
                ' in integer precision or a threshold in double'...
                ' precision.']);
        end
        
        function [left_data,left_labels,left_distribution,...
                right_data,right_labels,right_distribution]=...
                splitTreeData(featureDimension,featureValue,train_data,train_labels)
            value = train_data(featureValue,featureDimension);
            
            l_indices = train_data(:,featureDimension)<=value;
            r_indices = train_data(:,featureDimension)>value;
            left_data = train_data(l_indices);
            right_data = train_data(r_indices);
            left_labels = train_labels(l_indices);
            right_labels = train_labels(r_indices);
            
            classSize = size(obj.classes,1);
            left_distribution = zeros(classSize,1);
            right_distribution = zeros(classSize,1);
            for i=1:classSize
                left_distribution(i) =...
                    size(find(strcmp(left_labels,obj.classes{i})),1);
                right_distribution(i) =...
                    size(find(strcmp(right_labels,obj.classes{i})),1);
            end
        end
        
    end
end

