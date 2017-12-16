function [sift_features,metrics, validPoints]=SIFT_extractor(image)

big_im=imresize(image,4,'Antialiasing',true);

big_im=single(rgb2gray(big_im));

[f,d]=vl_sift(big_im,'PeakThresh',3,'edgethresh',8);
% f is 4 x m and d is 128 (n) x m;
sift_features=im2double(d'); % m x n
m=size(sift_features,1);
metrics=ones(m,1); % m x 1
location=f(1:2,:);
validPoints=location'; % m x 2
end

