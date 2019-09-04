function ieIdx = findIePerPix(ts, multiTriggerWindow)

%Ensure time order
[ts, idx] = sort(ts);

%Find IE by looking at time deltas
multiEvent = cat(1,diff(ts),Inf)<=multiTriggerWindow;
ieIdx = diff(cat(1,0,multiEvent))==1;
    
ieIdx = idx(ieIdx);
