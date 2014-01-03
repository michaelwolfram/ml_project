classdef BinaryTree
    %BINARYTREE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % Depth of this tree.
        depth;
        % All possible classes. 
        classes;
        % Used impurity measure of this tree.
        impurityMeasure;
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
        boolTests;
    end
    
    methods
        % Constructor.
        function obj=BinaryTree(depth, classes, impurityMeasure, varargin)
            obj.depth = depth;
            obj.classes = classes;
            obj.impurityMeasure = impurityMeasure;
            argSize = size(varargin)
            varargin
        end
        
        % Train a tree with some training data
        function obj=train(obj, trainingData)
            %%This is not wrong but also not right though. classifiers will
            %%be an array of feature attributes. Therefore, we must do
            %%things like obj.featuresAttributes(i,j) = ...
            
            % extract necessary information
            r = classifiers(1,:);
            c = classifiers(2,:);
            winWidth = classifiers(3,:);
            winHeight = classifiers(4,:);
            type = classifiers(5,:);
            obj.featuresType = type;
            obj.featuresAttributes = classifiers(6:end,:);
            
            % extract or build positions for rectangles with corners
            % [m1, n1, m2, n2; ...] m = row, n = column
            obj.numFeatures=size(classifiers,2);
            for i=1:obj.numFeatures
                r_i = r(i);
                c_i = c(i);
                winWidth_i = winWidth(i);
                winHeight_i = winHeight(i);
                
                switch (type(i))
                    case 1
                        obj.featuresPositions{i} = ...
                            [r_i c_i (r_i+winHeight_i-1) (c_i+ceil(winWidth_i/2)-1); ...
                            r_i (c_i+ceil(winWidth_i/2)) (r_i+winHeight_i-1) (c_i+winWidth_i-1)];
                        
                    case 2
                        obj.featuresPositions{i} = ...
                            [r_i c_i (r_i+ceil(winHeight_i/2)-1) (c_i+winWidth_i-1); ...
                            (r_i+ceil(winHeight_i/2)) c_i (r_i+winHeight_i-1) (c_i+winWidth_i-1)];
                        
                    case 3
                        obj.featuresPositions{i} = ...
                            [r_i c_i (r_i+winHeight_i-1) ceil(c_i+(winWidth_i/3)-1); ...
                            r_i ceil(c_i+(winWidth_i/3)) (r_i+winHeight_i-1) ceil(c_i+(2*winWidth_i/3)-1); ...
                            r_i ceil(c_i+(2*winWidth_i/3)) (r_i+winHeight_i-1) (c_i+winWidth_i-1)];
                        
                    case 4
                        obj.featuresPositions{i} = ...
                            [r_i c_i ceil(r_i+(winHeight_i/3)-1) (c_i+winWidth_i-1); ...
                            ceil(r_i+(winHeight_i/3)) c_i ceil(r_i+(2*winHeight_i/3)-1) (c_i+winWidth_i-1); ...
                            ceil(r_i+(2*winHeight_i/3)) c_i (r_i+winHeight_i-1) (c_i+winWidth_i-1)];
                        
                    case 5
                        obj.featuresPositions{i} = ...
                            [r_i c_i (r_i+ceil(winHeight_i/2)-1) (c_i+ceil(winWidth_i/2)-1); ...
                            r_i (c_i+ceil(winWidth_i/2)) (r_i+ceil(winHeight_i/2)-1) (c_i+winWidth_i-1); ...
                            (r_i+ceil(winHeight_i/2)) c_i (r_i+winHeight_i-1) (c_i+ceil(winWidth_i/2)-1); ...
                            (r_i+ceil(winHeight_i/2)) (c_i+ceil(winWidth_i/2)) (r_i+winHeight_i-1) (c_i+winWidth_i-1)];
                end
            end
        end
        
        % computes the feature values for the given patch (from integral image)
        function classification = Classify(obj, featureVector)
            % so here we already initialized the HaarFeatures object with
            % the featured extracted from Classifiers.mat. Therefore, we
            % now want to extract these features in the given image patch.
            % Thus, all the members of this class need to be matrices
            % containing the necessary information for EVERY single
            % feature.
            
            featureResponses = zeros(1,obj.numFeatures);
            returnValues = zeros(1,obj.numFeatures);
            
            for i = 1:obj.numFeatures
                
                % for faster access:
                FP = obj.featuresPositions{i};
                FP = ceil(FP.*s);
                FA = obj.featuresAttributes(:,i);
                %%%%%%%%
                % IS IT NECESSARY SO SCALE THESE FOUR VALUES, TOO!?!?
                %%%%%%%%
                mean = FA(1);
                maxPos = FA(3);
                minPos = FA(4);
                R = FA(5);
                %%%%%%%%
                
                %
                %      c1      c2      c3
                %
                % r1    -----------------
                %       |       |       |
                %       |       |       |
                % r2    |---------------|
                %       |       |       |
                %       |       |       |
                % r3    -----------------
                %
                
                switch (obj.featuresType(i))
                    case 1
                        %           B C
                        %  A ----------------- D
                        %    |       |       |
                        %    |       |       |
                        %    |       |       |
                        %    |       |       |
                        %    |       |       |
                        %  E ----------------- H
                        %           F G
                        %
                        % result = rect1+rect2 = (F-E-B+A) + (H-G-D+C)
                        
                        A = patch(FP(1,1),FP(1,2));
                        B = patch(FP(1,1),FP(1,4));
                        C = patch(FP(2,1),FP(2,2));
                        D = patch(FP(2,1),FP(2,4));
                        E = patch(FP(1,3),FP(1,1));
                        F = patch(FP(1,3),FP(1,4));
                        G = patch(FP(2,3),FP(2,2));
                        H = patch(FP(2,3),FP(2,4));
                        
                        featureResponses(i) = (F-E-B+A) + (H-G-D+C); % :D
                        
                    case 2
                        %
                        %  A ----------------- B
                        %    |               |
                        %  C |               | D
                        %    |---------------|
                        %  E |               | F
                        %    |               |
                        %  G ----------------- H
                        %
                        % result = rect1+rect2 = (D-C-B+A) + (H-G-F+E)
                        
                        A = patch(FP(1,1),FP(1,2));
                        B = patch(FP(1,1),FP(1,4));
                        C = patch(FP(1,3),FP(1,2));
                        D = patch(FP(1,3),FP(1,4));
                        E = patch(FP(2,1),FP(2,2));
                        F = patch(FP(2,1),FP(2,4));
                        G = patch(FP(2,3),FP(2,2));
                        H = patch(FP(2,3),FP(2,4));
                        
                        featureResponses(i) = (D-C-B+A) + (H-G-F+E); % :D
                        
                    case 3
                        
                        %           B C     D E
                        %  A ------------------------- F
                        %    |       |       |       |
                        %    |       |       |       |
                        %    |       |       |       |
                        %    |       |       |       |
                        %    |       |       |       |
                        %    |       |       |       |
                        %    |       |       |       |
                        %    |       |       |       |
                        %  G ------------------------- L
                        %           H I     J K
                        %
                        % result = rect1-rect2+rect3 = (H-G-B+A) - (J-I-D+C) + (L-K-F+E)
                        
                        A = patch(FP(1,1),FP(1,2));
                        B = patch(FP(1,1),FP(1,4));
                        G = patch(FP(1,3),FP(1,2));
                        H = patch(FP(1,3),FP(1,4));
                        C = patch(FP(2,1),FP(2,2));
                        D = patch(FP(2,1),FP(2,4));
                        I = patch(FP(2,3),FP(2,2));
                        J = patch(FP(2,3),FP(2,4));
                        E = patch(FP(3,1),FP(3,2));
                        F = patch(FP(3,1),FP(3,4));
                        K = patch(FP(3,3),FP(3,2));
                        L = patch(FP(3,3),FP(3,4));
                        
                        featureResponses(i) = ...
                            (H-G-B+A) - (J-I-D+C) + (L-K-F+E);
                        
                    case 4
                        
                        %
                        %
                        %  A ------------------------- B
                        %    |                       |
                        %  C |                       | D
                        %    |-----------------------|
                        %  E |                       | F
                        %  G |                       | H
                        %    |-----------------------|
                        %  I |                       | J
                        %    |                       |
                        %  K ------------------------- L
                        %
                        % result = rect1-rect2+rect3 =
                        %        = (D-C-B+A) - (H-G-F+E) + (L-K-J+I)
                        
                        
                        A = patch(FP(1,1),FP(1,2));
                        B = patch(FP(1,1),FP(1,4));
                        C = patch(FP(1,3),FP(1,2));
                        D = patch(FP(1,3),FP(1,4));
                        E = patch(FP(2,1),FP(2,2));
                        F = patch(FP(2,1),FP(2,4));
                        G = patch(FP(2,3),FP(2,2));
                        H = patch(FP(2,3),FP(2,4));
                        I = patch(FP(3,1),FP(3,2));
                        J = patch(FP(3,1),FP(3,4));
                        K = patch(FP(3,3),FP(3,2));
                        L = patch(FP(3,3),FP(3,4));
                        
                        featureResponses(i) = ...
                            (D-C-B+A) - (H-G-F+E) + (L-K-J+I);
                        
                    case 5
                        %          B   E
                        %  A ----------------- F
                        %    |  1    |    2  |
                        %  C |     D | G     | H
                        %    |---------------|
                        %  I |     J | M     | N
                        %    |  3    |    4  |
                        %  K ----------------- P
                        %          L   O
                        % result = rect1-rect2+rect3-rect4 =
                        %        = (D-C-B+A) - (H-G-F+E) ...
                        %           + (L-K-J+I) - (P-O-N+M)
                        
                        A = patch(FP(1,1),FP(1,2));
                        B = patch(FP(1,1),FP(1,4));
                        C = patch(FP(1,3),FP(1,2));
                        D = patch(FP(1,3),FP(1,4));
                        E = patch(FP(2,1),FP(2,2));
                        F = patch(FP(2,1),FP(2,4));
                        G = patch(FP(2,3),FP(2,2));
                        H = patch(FP(2,3),FP(2,4));
                        I = patch(FP(3,1),FP(3,2));
                        J = patch(FP(3,1),FP(3,4));
                        K = patch(FP(3,3),FP(3,2));
                        L = patch(FP(3,3),FP(3,4));
                        M = patch(FP(4,1),FP(4,2));
                        N = patch(FP(4,1),FP(4,4));
                        O = patch(FP(4,3),FP(4,2));
                        P = patch(FP(4,3),FP(4,4));
                        
                        featureResponses(i) = ...
                            (D-C-B+A) - (H-G-F+E) + (L-K-J+I) - (P-O-N+M);
                end
                % assign actual output (+/- or face/non-face)
                
                t = featureResponses(i);
                if (t <= (mean+abs(maxPos-mean)*(R-5)/50) && ...
                        t >= (mean-abs(mean-minPos)*(R-5)/50))
                    returnValues(i) = -1;
                else
                    returnValues(i) = 1;
                end
            end
            % print result ;D
            %             display(returnValues)
        end
        
    end
    
end

