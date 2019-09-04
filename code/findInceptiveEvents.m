function ie = findInceptiveEvents(pts, multiTriggerWindow)

%Takes in struct of events and returns a filtered struct containing only
%inceptive events

sizeData = [max(pts.y)+1 max(pts.x)+1];

ie = false(numel(pts.x),1);

%Positive Intensity
idx = find(pts.p==max(pts.p));
if ~isempty(idx)
    hasDataIdx = sub2ind(sizeData,pts.y(idx)+1,pts.x(idx)+1);
    [~,~,pixIdx] = unique(hasDataIdx,'stable');
    for loop = 1:max(pixIdx)
        currentIdx = find(pixIdx == loop);
        ieIdx = findIePerPix(pts.ts(idx(currentIdx)),multiTriggerWindow);
        ie(idx(currentIdx(ieIdx))) = true;
    end
end

%Negative Intensity
idx = find(pts.p==min(pts.p));
if ~isempty(idx)
    hasDataIdx = sub2ind(sizeData,pts.y(idx)+1,pts.x(idx)+1);
    [~,~,pixIdx] = unique(hasDataIdx,'stable');
    for loop = 1:max(pixIdx)
        currentIdx = find(pixIdx == loop);
        ieIdx = findIePerPix(pts.ts(idx(currentIdx)),multiTriggerWindow);
        ie(idx(currentIdx(ieIdx))) = true;
    end
end

