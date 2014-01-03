function [ H ] = dlt( x, xPrime )
%DLT Summary of this function goes here
%   Detailed explanation goes here

% Objective
%   Given n ? 4 2D to 2D point correspondences { xi ? xi } , determine the 2D homography
%   matrix H such that xi= H xi.
% Algorithm
% (i) For each correspondence xi ? xi compute the matrix A i from (4.1). Only the ?rst two
%   rows need be used in general.
% (ii) Assemble the n 2 × 9 matrices A i into a single 2n × 9 matrix A .
% (iii) Obtain the SVD of A (section A4.4(p585)). The unit singular vector corresponding to
%   the smallest singular value is the solution h. Speci?cally, if A = UDV T
%   with D diagonal
%   with positive diagonal entries, arranged in descending order down the diagonal, then h
%   is the last column of V .
% (iv) The matrix H is determined from h as in (4.2).

n = size( x, 2 );

% Normalize points in the "original" image.
translation = (sum(x'))'/n;
distance = 0;
for i=1:n
    x(:,i)=x(:,i)-translation;
    distance = distance + norm(x(:,i));
end
distance = distance / n;
x = x / distance * sqrt(2);

% Normalize points in the warped image.
translationP = (sum(xPrime'))'/n;
distanceP = 0;
for i=1:n
    xPrime(:,i)=xPrime(:,i)-translationP;
    distanceP = distanceP + norm(xPrime(:,i));
end
distanceP = distanceP / n;
xPrime = xPrime / distanceP * sqrt(2);


% TODO Shouldn't this be done before normalizing the points?
% Make the points homogeneous.
x = padarray(x,1,1,'post');
xPrime = padarray(xPrime,1,1,'post');


% Compute the matrices A_i and the A.
A = [];
for i=1:n
    xiPrime = xPrime(1,i);
    yiPrime = xPrime(2,i);
    wiPrime = xPrime(3,i);
    
    xiT = x(:,i)';
    A_i = [0, 0, 0,    -wiPrime * xiT,   yiPrime * xiT;
        wiPrime * xiT,     0, 0, 0,  -xiPrime * xiT];
    
    A = [A;A_i];
end;

% Singular Value Decomposition of A.
A(~isfinite(A))=0;
A(isnan(A))=0;
[U,D,V] = svd(A);

H=[V(1:3,9),V(4:6,9),V(7:9,9)]';

% Should we use this normalization?! I think so. Everyone does it. ;)
H = H / H(3,3);

% Back-transform H
% T = warped image, U original image transformations.
% Compute transformation matrices.
s = sqrt(2) / distance;
U = [s 0 -translation(1)*s ; 0 s -translation(2)*s ; 0 0 1];
sP = sqrt(2) / distanceP;
T = [sP 0 -translationP(1)*sP ; 0 sP -translationP(2)*sP ; 0 0 1];
H = inv(T)*H*U;

H = H / H(3,3);

end


