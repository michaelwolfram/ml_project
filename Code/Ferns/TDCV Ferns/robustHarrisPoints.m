function [ robustCorners ] = robustHarrisPoints( source, borderSize )
%robustHarrisPoints Summary of this function goes here
%   Detailed explanation goes here

iterations = 20;    % how many random transformations? / accuracy
robustness = 1;     % when is corner robust?
searchwindow = -3:3;% in which neighborhood do we serach the keypoint in the backtransformation
maxNumber = 20;

robustCorners = [];

A = [ 1 0 0; 0 1 0; 0 0 1];
corners = zeros(size(source));  % here we accumlate the corners from different backtransformations

while (size(robustCorners,1)<4)
    display('RobustHPts loop on')
    tic
    for i=1:iterations
        % random affine transformation formula from the slides
        theta = -pi + 2*pi*rand;    %[-pi; +pi]
        phi = -pi + 2*pi*rand;
        lambda_1 = 0.6 + 0.9*pi*rand;   %[0.6; 1.5]
        lambda_2 = 0.6 + 0.9*pi*rand;

        S = diag([lambda_1, lambda_2]);

        R_theta = [cos(theta) -sin(theta); sin(theta) cos(theta)];
        R_phi = [cos(phi) -sin(phi); sin(phi) cos(phi)];

        A(1:2,1:2) = R_theta*inv(R_phi)*S*R_phi;    
        %A(1:2,1:2) = randn(2);      % random affine transformation

        tform = affine2d(A);
        [transI,R] = imwarp(source,tform);  % transform the image

        C = corner(transI);             % harris corner
        Cworld=zeros(size(C));
        [Cworld(:,1),Cworld(:,2)]=intrinsicToWorld(R,C(:,1),C(:,2));
        C_inv = transformPointsInverse(tform,Cworld);   % backtransform works so randomly....
        for j=1:size(C_inv,1)
            x = round(C_inv(j,1));
            y = round(C_inv(j,2));
            if(x<1 || x>size(source,2) || y<1 || y>size(source,1))  % check if it worked
                continue;
            end

            corners(y,x) = corners(y,x) + 1;    % increase the counting
        end
    end
    display('RobustHPts loop off')
    toc

    % figure(3);
    % imshow(corners);
    C = corner(source);     % ok now find the corner in the original image and check which one is robust
    robustCorners=zeros(size(C));
    numberOfRobustCroners = 0;      % we dont want dynamic lists

    for c=1:size(C,1)
        x = round(C(c,1));
        y = round(C(c,2));
        if(x<borderSize || x> size(corners,2)-borderSize || y<borderSize || y> size(corners,1)-borderSize)
            continue;
        end

        num = 0;    % number of keypoints in neighboorhood
        for i=searchwindow
            if(y+i <1 || y+i> size(corners,1))
                continue;
            end
            for j=searchwindow
                if(x+j <1 || x+j> size(corners,2))
                    continue;
                end    
                num = num + corners(y+i, x+j); 
            end
        end
        if(num>=robustness)  % if the number is bigger than a threshold
            numberOfRobustCroners = numberOfRobustCroners + 1;
            robustCorners(numberOfRobustCroners,:) = C(c,:);
        end
        if(numberOfRobustCroners>maxNumber)
            break;
        end         
    end

    robustCorners = robustCorners(1:numberOfRobustCroners,:);   %resize

end %while

 display('Number of Keypoint:');
 size(robustCorners)
 
 figure('name', 'robust harris points');
 imshow(source);
 hold on;
 plot(robustCorners(:,1), robustCorners(:,2), 'rx');
 
end
