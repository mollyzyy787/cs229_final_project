function [subimages]=cropimage(image,threshPercent)

larv=imread(image);
larv = double(larv);
larv = 0.299*larv(:,:,1) + 0.587*larv(:,:,2) + 0.114*larv(:,:,3);
larv = uint8(larv);

thresh = threshPercent*mean(mean(larv))/100;
bilarv=larv> thresh;
CC=bwconncomp(bilarv);
s=regionprops(CC);


areas=[s.Area];
centroids=[s.Centroid];
boundingbox=zeros(length(areas),4);
for i=1:length(areas)
    boundingbox(i,:)=s(i).BoundingBox;
end


[maxArea,Ind]=max(areas);

blobbox=boundingbox(Ind,:);

subimages = imcrop(imread(image),[blobbox]);

end