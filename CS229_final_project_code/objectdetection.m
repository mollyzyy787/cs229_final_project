function bboxes = objectdetection(image)
load bag200mod.mat;
load categoryClassifier200mod.mat;

bboxes=[];
image=imread(image);
[m,n,~]=size(image);

% for window size n/5 * m/3
left0=mod(n,5)+1;
top0=mod(m,3)+1;
new_n=n-mod(n,5);
new_m=m-mod(m,5);
t_v=0:1:20;
t_h=0:1:40;
for k=1:length(t_v)
    for i=1:length(t_h)
        if t_h(i) == length(t_h)-1
           bb(i,:)=[left0+ceil(t_h(i)*new_n/50)-1,...
               top0+ceil(t_v(k)*new_m/30),new_n/5,new_m/3];
        elseif t_v(k)==length(t_v)-1
            bb(i,:)=[left0+ceil(t_h(i)*new_n/50),...
               top0+ceil(t_v(k)*new_m/30)-1,new_n/5,new_m/3];    
        else 
           bb(i,:)=[left0+ceil(t_h(i)*new_n/50),...
               top0+ceil(t_v(k)*new_m/30),new_n/5,new_m/3];
        end
        sample=imcrop(image,[bb(i,:)]);
        predictedLabel = predict(categoryClassifier, sample);
        if predictedLabel == 2
            bboxes=[bboxes; 
                    bb(i,:)];
        end

    end
end
%%
% for window size n/4 * m/2
left0=mod(n,4)+1;
top0=mod(m,2)+1;
new_n=n-mod(n,4);
new_m=m-mod(m,2);
t_v=0:1:10;
t_h=0:1:30;
for k=1:length(t_v)
    for i=1:length(t_h)
        if t_h(i) == length(t_h)-1
           bb(i,:)=[left0+ceil(t_h(i)*new_n/40)-1,...
               top0+ceil(t_v(k)*new_m/20),new_n/4,new_m/2];
        elseif t_v(k)==length(t_v)-1
            bb(i,:)=[left0+ceil(t_h(i)*new_n/40),...
               top0+ceil(t_v(k)*new_m/20)-1,new_n/4,new_m/2];    
        else 
           bb(i,:)=[left0+ceil(t_h(i)*new_n/40),...
               top0+ceil(t_v(k)*new_m/20),new_n/4,new_m/2];
        end
        sample=imcrop(image,[bb(i,:)]);
        predictedLabel = predict(categoryClassifier, sample);
        if predictedLabel == 2
            bboxes=[bboxes; 
                    bb(i,:)];
        end
    end
end



end