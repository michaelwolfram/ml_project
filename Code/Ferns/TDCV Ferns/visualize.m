function [ visualization ] = visualize( refI, inputI, fps_refI, fps_inputI )
%VISUALIZE Summary of this function goes here
%   Detailed explanation goes here

visualization = zeros(size(refI,1)+size(inputI,1), max(size(refI,2),size(inputI,2)));
visualization(1:size(refI,1), 1:size(refI,2)) = refI;
visualization(size(refI,1)+1:end, 1:size(inputI,2)) = inputI;


figure('name','matching');
imshow(visualization);
hold on;

for i=1:size(fps_refI,1)
    x = [fps_refI(i,1)  fps_inputI(i,1)];
    y = [fps_refI(i,2)  fps_inputI(i,2)+size(refI,1)];
    line(x,y);
end

end

