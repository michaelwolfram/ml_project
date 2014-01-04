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
        
        % Boolean tests of every node of the tree.
        % (      test 1     | ... |     test n      )
        %
        %  -----------------------------------------
        % | feature index 1 | ... | feature index n |
        % |-----------------------------------------|
        % |   threshold 1   | ... |   threshold n   |
        %  -----------------------------------------
        %
        %                      1
        %                     / \
        %                    2   3
        %                   / \ / \
        %                 ...  ... n
        allNodesList;
        leafsList;
        adjacencyMatrix;
    end
    
    methods
        % Constructor.
        function obj=BinaryTree(impurityMeasure, varargin)
            obj.impurityMeasure = impurityMeasure;
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
            
            i = 1;
            j = 1;
            treeHeight = 0;
            numLeafs = 0;
            abort = false;
            
            
            while ~abort
                currNode = obj.allNodesList(:,i);
                currDistribution = obj.splittedTrainingData{4,i};
                
%                 if() || () || (hier kann ich median(currDistribution)==0 && max(currDistribution)~=0)
               if true
                   % Mark node as leaf
                   
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
                   continue
               end
                
                i = i + 1;
                if i==j
                    abort = true;
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
        function giniValue=gini(obj, currPartition)
            partSize = size(currPartition);
            if partSize(1)~=1 || partSize(2)~=size(obj.classes,2)
                error(['Size of currPartition does not match number of'...
                    'possible classes.']);
            end
            s = sum(currPartition);
            if s == 0
                giniValue = 1;
            else
                giniValue = 1.0 - (sum(currPartition.*currPartition))...
                    /(s*s*1.0);
            end
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
        
        function [newCosts]=calcNewCosts(left, right)
            l = sum(left);
            r = sum(right);
            all = l + r;
            newCosts = (l*obj.gini(left) + r*obj.gini(right)) / all;
        end
        
        function [left_data,left_labels,right_data,right_labels]=splitTreeData(featureDimension,featureValue,train_data,train_labels)
            value = train_data(featureValue,featureDimension);
            
            l_indices = train_data(:,featureDimension)<=value;
            r_indices = train_data(:,featureDimension)>value;
            left_data = train_labels(l_indices);
            right_data = train_labels(r_indices);
            left_labels = train_labels(l_indices);
            right_labels = train_labels(r_indices);
        end
        
        function [left,right]=splitTreePi(featureDimension,featureValue,train_data,train_labels)
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
 
        function [featureDimension,featureValue,splitCosts]=findBestSplit(train_data,train_labels)
            curr_i = 0;
            curr_j = 0;
            curr_costs = inf;
            for i=1:size(train_data,1)
                for j=1:size(train_data,2)
                    [left,right] = splitTreePi(j,i,train_data,train_labels);
                    tmp = calcNewCosts(left,right);
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
end

