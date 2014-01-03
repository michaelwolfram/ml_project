function [ horizontalMask, verticalMask ] = gaussian_1d( sigma )
%[ horizontalMask, verticalMask ] = gaussian_1d( sigma )
%
%-sigma
%
%This function is our attempt to answer the question b) of the second
%exercise. The result generate1D_GF_vertical is a vertical one-dimensional 
%Gaussian filter with respect to the parameter sigma.
%
%WARNING: THE RESULT IS NORMALIZED (division by the sum of the mask components)

n=3*sigma;
if(mod(n,2)==0) %Even sizes must become uneven in order for the gaussian to be centered correctly
    n=n+1;
end
u = -(n-1)/2 : (n-1)/2;

horizontalMask = 1/sqrt(2*pi*sigma^2) * exp(-0.5 * u.^2 /sigma^2);
token=horizontalMask;
horizontalMask = token / sum(token);
verticalMask = horizontalMask( : );

end