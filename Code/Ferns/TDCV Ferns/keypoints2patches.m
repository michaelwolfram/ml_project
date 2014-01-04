function [ keypointList,patchList ] = keypoints2patches( Image, harrisOutput, patchSize, numPatches )
%KEYPOINT2PATCH
%This fuction produces patches of size patchSize around the keypoint
%obtained with the Harris Corner Detector


% fill first column of patchList, which contains numPatches many
% patches of the keypoints from the keypointList
keypointList = harrisOutput; %other, better implementation of harris
keypointNumber = size(keypointList,1);

patchList=cell(keypointNumber,numPatches);
tic
display('k2p: first loop on')
for i=1:keypointNumber
    patch=zeros(patchSize);
    
    for k=-(patchSize(1)-1)/2:(patchSize(1)-1)/2
        for l=-(patchSize(2)-1)/2:(patchSize(2)-1)/2
            patch(k+(patchSize(1)-1)/2+1,l+(patchSize(2)-1)/2+1)=...
                Image(keypointList(i,2)+k,keypointList(i,1)+l);
        end
    end
    patchList{i,1}=patch;
    %     figure('name','Patch');
    %     imshow(patchList{i,1});
end
display('k2p: first loop off')
toc
% fill the rest of the patchlist
tic
display('k2p: second loop on')
for i=1:keypointNumber
    for j=2:numPatches
        patchList{i,j}=generatePatch(patchList{i,1});
        %         figure('name','Transformed patch');
        %         imshow(patchList{i,j});
    end
    
end
display('k2p: second loop off')
toc
info=strcat('Variable keyPointNumber in keypoints2patches is: ',num2str(keypointNumber));
display(info);
%tit=strcat('Content of the patchList, keyPointNumber =',num2str(keypointNumber));
%display('I BREATHE!')
%figure('name',tit);

% for i=1:keypointNumber
%     %display('I BREATHE Again!')
%     display(keypointNumber)
%     subplot(round((keypointNumber+1)/4),4,i)
%     hold on;
%     imshow(patchList{i,1});
%     hold off;
% end

end

