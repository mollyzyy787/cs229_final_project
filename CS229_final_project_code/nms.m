function pickedboxes = nms(boxes, overlap)

% pick = nms(boxes, overlap) 
% Non-maximum suppression.
% Greedily select high-scoring detections and skip detections
% that are significantly covered by a previously selected detection.

if isempty(boxes)
  pick = [];
else
  x = boxes(:,1);
  y = boxes(:,2);
  W = boxes(:,3);
  H = boxes(:,4);
  x1 = x;
  y1 = y;
  x2 = x+W;
  y2 = y+H;
  s = y2;
  area = (W+1) .* (H+1);

  [vals, I] = sort(s);
  pick = [];
  while ~isempty(I)
    last = length(I);
    i = I(last);
    pick = [pick; i];
    suppress = [last];
    for pos = 1:last-1
      j = I(pos);
      xx1 = max(x1(i), x1(j));
      yy1 = max(y1(i), y1(j));
      xx2 = min(x2(i), x2(j));
      yy2 = min(y2(i), y2(j));
      w = xx2-xx1+1;
      h = yy2-yy1+1;
      if w > 0 && h > 0
        % compute overlap 
        o = w * h / area(j);
        if o > overlap
          suppress = [suppress; pos];
        end
      end
    end
    I(suppress) = [];
  end  
end
pickedboxes = boxes(pick,:);
end