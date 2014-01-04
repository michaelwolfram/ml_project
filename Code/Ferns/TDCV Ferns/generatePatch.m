function [ randPatch ] = generatePatch( orgPatch )
%GENERATEPATCH
% this function generates one random patch out of the given original patch

% create transformation matrices
A = [ 1 0 0; 0 1 0; 0 0 1];
theta = -pi + 2*pi*rand;    %[-pi; +pi]
phi = -pi + 2*pi*rand;
lambda_1 = 0.6 + 0.9*pi*rand;   %[0.6; 1.5]
lambda_2 = 0.6 + 0.9*pi*rand;

S = diag([lambda_1, lambda_2]);

R_theta = [cos(theta) -sin(theta); sin(theta) cos(theta)];
R_phi = [cos(phi) -sin(phi); sin(phi) cos(phi)];

A(1:2,1:2) = R_theta*inv(R_phi)*S*R_phi;

tform = maketform('affine', A);

% adjust original patch to values slightly bigger than 0
sOrg=size(orgPatch);
sOrgHalf=round(sOrg/2);
adjust = 0.000001*ones(sOrg);
adjPatch = orgPatch+adjust;

transPatch = imtransform(adjPatch,tform,'XYScale',1);
sTrans=size(transPatch);
sTransHalf=round(sTrans/2);

randPatch = zeros(sOrg);
for i=-(sOrg(1)-1)/2:(sOrg(1)-1)/2
    for j=-(sOrg(2)-1)/2:(sOrg(2)-1)/2
        if (sTransHalf(1)+j>0 && sTransHalf(1)+j<=sTrans(1) && ...
                sTransHalf(2)+i>0 && sTransHalf(2)+i <=sTrans(2)...
                && transPatch(sTransHalf(1)+j, sTransHalf(2)+i) ~= 0)
            randPatch(sOrgHalf(2)+j,sOrgHalf(1)+i)=transPatch(sTransHalf(1)+j, sTransHalf(2)+i);
        else
            randPatch(sOrgHalf(2)+j,sOrgHalf(1)+i)=rand(1);
        end
    end
end

% figure('name','transformed patch');
% imshow(patch);
end

