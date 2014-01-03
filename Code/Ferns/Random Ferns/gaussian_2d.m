function [ mask ] = gaussian_2d( sigma)%,Image)
%RESULT=GAUSSIAN_2D(SIGMA,IMAGE)
%-IMAGE: image that is to be filtered
%-sigma: standard deviation, has to be an integred
%
%WARNING THIS MASK IS NORMALIZED THROUGH A DIVISION OF THE MASK BY
%THE SUM OF THE MASK COMPONENTS
%
%This function is our attempt to answer the question 2 a) of the first
% exercise sheet. The RESULT is the filtered source image, by a 2D Gaussian
% filter of standard deviation sigma.

%Initialisation of the mask
mask=zeros(3*sigma);
n=3*sigma;
if(mod(n,2)==0) %Even sizes must become uneven in order for the gaussian to be centered correctly
n=n+1;            
end
for i=1:n
    for j=1:n
        u=j-(n+1)/2; %u index starts at 0, j index at 1, therefore (n+1)/2
        v=i-(n+1)/2; %the same as above
        mask(i,j)=1/(2*pi*sigma^2)*exp(-0.5*(u^2+v^2)/sigma^2);
    end
end

%Normalization: division by the sum of the masks components
sumMask=sum(mask(:));
token=mask;
mask=token/sumMask;