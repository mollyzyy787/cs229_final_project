function slidingwindow(image)
image=imread(image);
[m,n,~]=size(image);

% for window size n/5 * m/3
left0=mod(n,5)+1;
top0=mod(m,3)+1;
new_n=n-mod(n,5);
new_m=m-mod(m,5);
figure()
imshow(image); 
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
        drawnow
        h=rectangle('Position',[bb(i,:)],'EdgeColor','r', 'LineWidth', 2);
        pause(0.01)
        set(h,'Visible','off')
    end
end
%%
% for window size n/4 * m/2
left0=mod(n,4)+1;
top0=mod(m,2)+1;
new_n=n-mod(n,4);
new_m=m-mod(m,2);
figure()
imshow(image); 
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
        drawnow
        h=rectangle('Position',[bb(i,:)],'EdgeColor','r', 'LineWidth', 2);
        pause(0.01)
        M(i+(k-1)*length(t_h))=getframe;
        set(h,'Visible','off') 
    end
end

%
% for window size n/2 * m
left0=mod(n,2)+1;
top0=1;
new_n=n-mod(n,2);
new_m=m-1;
figure()
imshow(image); 
t_h=0:1:10;
for i=1:length(t_h)
    if t_h(i) == length(t_h)-1
       bb(i,:)=[left0+ceil(t_h(i)*new_n/20)-1,...
           top0,new_n/2,new_m];
    else 
       bb(i,:)=[left0+ceil(t_h(i)*new_n/20),...
           top0,new_n/2,new_m];
    end
    drawnow
    h=rectangle('Position',[bb(i,:)],'EdgeColor','r', 'LineWidth', 2);
    pause(0.1)
    M(i+length(t_h))=getframe;
    set(h,'Visible','off') 
end

% % for window size n * m/2
left0=1;
top0=mod(m,2)+1;
new_n=n-1;
new_m=m-mod(m,2);
figure()
imshow(image); 
t_v=0:1:10;
for k=1:length(t_v)
    if t_v(k)==length(t_v)-1
       bb(k,:)=[left0,...
           top0+ceil(t_v(k)*new_m/20)-1,new_n,new_m/2];    
    else 
       bb(k,:)=[left0,...
           top0+ceil(t_v(k)*new_m/20),new_n,new_m/2];
    end
    drawnow
    h=rectangle('Position',[bb(k,:)],'EdgeColor','r', 'LineWidth', 2);
    pause(0.1)
    set(h,'Visible','off') 
end


end