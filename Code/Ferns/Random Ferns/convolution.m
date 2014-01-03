function [ Conv_image ] = convolution( Image,Mask,border_treatment )
%Conv_image=CONV_EX1(IMAGE,Mask,BORDER_TREATMENT)
%-IMAGE
%-Mask
%-BORDER_TREATMENT
%
%This function is our attempt to answer the question a) of the first
% exercise. The result Conv_image, is the convoluted original image.


%Get Mask dimensions.
MaskSize=size(Mask);
m=MaskSize(1);
n=MaskSize(2);
%Get image dimensions.
ImageSize=size(Image);
m_i=ImageSize(1);
n_i=ImageSize(2);
%Initialization of the result variable
Conv_image=zeros(size(Image));

%Resized Image
r_Image=zeros(m_i+(m-1),n_i+(n-1));
r_Image(...
    (m-1)/2+1:(m_i+(m-1)/2),...
    (n-1)/2+1:(n_i+(n-1)/2))=Image;
%Pad image.
if strcmp(border_treatment,'mirror')
    %upper border without corners
    r_Image(1:(m-1)/2,...
        ((n-1)/2+1):(n_i+(n-1)/2))=Image((m-1)/2:-1:1,:);
    %lower border without corners
    r_Image( ((m-1)/2+m_i+1):end,...
        ((n-1)/2+1):(n_i+(n-1)/2))=Image(end:-1:(m_i-(m-1)/2+1),:);
    %left side without corners
    r_Image(((m-1)/2+1):(m_i+(m-1)/2),...
        1:(n-1)/2)=Image(:,(n-1)/2:-1:1);
    %right side without corners
    r_Image(((m-1)/2+1):(m_i+(m-1)/2),...
        (n_i+(n-1)/2+1):end)=Image(:,end:-1:(n_i-(n-1)/2+1));
    %corners upper left
    r_Image(1:(m-1)/2,1:(n-1)/2)=Image((m-1)/2:-1:1,(n-1)/2:-1:1);
    %corners upper right
    r_Image(1:(m-1)/2,(n_i+(n-1)/2+1):end)=Image((m-1)/2:-1:1,end:-1:(n_i-(n-1)/2+1));
    %corners lower left
    r_Image((m_i+(m-1)/2+1):end,1:(n-1)/2)=Image(end:-1:(m_i-(m-1)/2+1),(n-1)/2:-1:1);
    %corners lower right
    r_Image((m_i+(m-1)/2+1):end,(n_i+(n-1)/2+1):end)=Image(end:-1:(m_i-(m-1)/2+1),end:-1:(n_i-(n-1)/2+1));
end  
if strcmp(border_treatment,'duplicate')
    %upper border without corners
    for i=1:(m-1)/2
        r_Image(i,...
        (n-1)/2+1:(n_i+(n-1)/2))=Image(1,:);
    end
    %lower border without corners
    for i=0:(m-1)/2
    r_Image( (m_i+(m-1)/2)+i,...
        (n-1)/2+1:(n_i+(n-1)/2))=Image(end,:);
    end
    %left side without corners
    for i=1:(n-1)/2
    r_Image((m-1)/2+1:(m_i+(m-1)/2),...
        i)=Image(:,1);
    end
    %right side without corners
    for i=0:(n-1)/2
    r_Image((m-1)/2+1:(m_i+(m-1)/2),...
        (n_i+(n-1)/2)+i)=Image(:,end);
    end
    %corners upper left
    r_Image(1:(m-1)/2,1:(n-1)/2)=Image(1,1)*ones((m-1)/2,(n-1)/2);
    %corners upper right
    r_Image(1:(m-1)/2,(n_i+(n-1)/2+1):end)=Image(1,end)*ones((m-1)/2,(n-1)/2);
    %corners lower left
    r_Image((m_i+(m-1)/2+1):end,1:(n-1)/2)=Image(end,1)*ones((m-1)/2,(n-1)/2);
    %corners lower right
    r_Image((m_i+(m-1)/2+1):end,(n_i+(n-1)/2+1):end)=Image(end,end)*ones((m-1)/2,(n-1)/2);
end  

if (~strcmp(border_treatment,'duplicate')&&~strcmp(border_treatment,'mirror'))
    display('Wrong treatment desired in function convolution. Please refer to documentation.')
    Conv_image=Image;
    return;
end
%Convolute.
 for x = 1:m_i
     for y= 1:n_i
         
         %The result image has the same size as the original Image, not the
         %padded image.
         for i=1:m
             for j=1:n
                token=Conv_image(x,y);
                x_Ri=x+(m-1)/2;
                y_Ri=y+(n-1)/2;
                %To have the same index as in the formula given.
                i_new=i-(m-1)/2-1;
                j_new=j-(n-1)/2-1;
                Conv_image(x,y)=token+Mask(i,j)*r_Image(x_Ri-(i_new),y_Ri-(j_new));
             end
         end
     end
end

end