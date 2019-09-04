function I = pts2image(pts, ie)

%Generate an RGB image from points

if ~exist('ie', 'var')
    %IE marks which pts to use for Red and Blue Channels
    %Assume all points are good if no labels
    ie = true(numel(pts.x),1);
end

%Return a black image if no points present
if isempty(pts.x)
    I = zeros(224,224,3);
    return
end

%Subtract off minimum indexes
pts.x = pts.x - min(pts.x);
pts.y = pts.y - min(pts.y);
pts.ts = pts.ts - min(pts.ts);
maxVal = max(max([pts.x pts.y]));
maxTime = max(pts.ts);

%Positive Intensity (blue)
idx = pts.p>0 & ie;
pos = zeros([maxVal+1 maxVal+1]);
if ~(sum(idx)==0)
    hasDataIdx = sub2ind(size(pos),pts.y(idx)+1,pts.x(idx)+1);
    [dataIdx,~,pixIdx] = unique(hasDataIdx,'stable');
    pixMean = accumarray(pixIdx,pts.ts(idx),[],@mean);
    pos(dataIdx) = pixMean;
    pos = pos ./ maxTime;
end
%For pix with no IE, use a mean of all pts
idx = pts.p>0;
pos2 = zeros([maxVal+1 maxVal+1]);
if ~(sum(idx)==0)
    hasDataIdx = sub2ind(size(pos),pts.y(idx)+1,pts.x(idx)+1);
    [dataIdx,~,pixIdx] = unique(hasDataIdx,'stable');
    pixMean = accumarray(pixIdx,pts.ts(idx),[],@mean);
    pos2(dataIdx) = pixMean;
    pos2 = pos2 ./ maxTime;
    pos(pos==0) = pos2(pos==0);
end

%Negative Intensity (red)
idx = pts.p<=0 & ie;
neg = zeros([maxVal+1 maxVal+1]);
if ~(sum(idx)==0)
    hasDataIdx = sub2ind(size(neg),pts.y(idx)+1,pts.x(idx)+1);
    [dataIdx,~,pixIdx] = unique(hasDataIdx,'stable');
    pixMean = accumarray(pixIdx,pts.ts(idx),[],@mean);
    neg(dataIdx) = pixMean;
    neg = neg ./ maxTime;
end
%For pix with no IE, use a mean of all pts
idx = pts.p<=0;
neg2 = zeros([maxVal+1 maxVal+1]);
if ~(sum(idx)==0)
    hasDataIdx = sub2ind(size(pos),pts.y(idx)+1,pts.x(idx)+1);
    [dataIdx,~,pixIdx] = unique(hasDataIdx,'stable');
    pixMean = accumarray(pixIdx,pts.ts(idx),[],@mean);
    neg2(dataIdx) = pixMean;
    neg2 = neg2 ./ maxTime;
    neg(neg==0) = neg2(neg==0);
end

%Activity Count (green)
cnt = zeros([maxVal+1 maxVal+1]);
hasDataIdx = sub2ind(size(cnt),pts.y+1,pts.x+1);
[dataIdx,~,pixIdx] = unique(hasDataIdx,'stable');
ptsPerPix = accumarray(pixIdx,1,[],@sum);
cnt(dataIdx) = ptsPerPix./max(ptsPerPix(:));

%Stack bands together
I(:,:,1) = neg;
I(:,:,2) = cnt;
I(:,:,3) = pos;

%Ensure output is 224x224
if isempty(I)
    I = zeros(224,224,3);
else
    I = imresize(I,[224 224]);
end

%Bicubic interpolations can cause values to go outside of 0/1 (fix this)
I(I>1) = 1;
I(I<0) = 0;
