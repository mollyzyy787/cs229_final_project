function plotbboxes(image,bboxes)
image=imread(image);
numBoxes=size(bboxes,1);
figure()
imshow(image); hold on;
    for i=1:numBoxes
        rectangle('Position',[bboxes(i,:)],'EdgeColor','g', 'LineWidth', 2);hold on;
    end

end