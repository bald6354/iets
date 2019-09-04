%University of Dayton
%Inceptive Event Time Surfaces - ICIAR 2019
%29AUG2019

%Transfer Learning

%Run from 'code' directory

mainPath = ['..' filesep 'time_surfaces' filesep];

checkpointPath = [mainPath specDir filesep 'network_checkpoints' filesep];

if ~exist(checkpointPath, 'dir')
    mkdir(checkpointPath)
end

try
    net = googlenet;
    if isa(net,'SeriesNetwork')
        lgraph = layerGraph(net.Layers);
    else
        lgraph = layerGraph(net);
    end
    [learnableLayer,classLayer] = findLayersToReplace(lgraph);
    numClasses = 2;
    if isa(learnableLayer,'nnet.cnn.layer.FullyConnectedLayer')
        newLearnableLayer = fullyConnectedLayer(numClasses, ...
            'Name','new_fc', ...
            'WeightLearnRateFactor',10, ...
            'BiasLearnRateFactor',10);
    elseif isa(learnableLayer,'nnet.cnn.layer.Convolution2DLayer')
        newLearnableLayer = convolution2dLayer(1,numClasses, ...
            'Name','new_conv', ...
            'WeightLearnRateFactor',10, ...
            'BiasLearnRateFactor',10);
    end
    lgraph = replaceLayer(lgraph,learnableLayer.Name,newLearnableLayer);
    newClassLayer = classificationLayer('Name','new_classoutput');
    lgraph = replaceLayer(lgraph,classLayer.Name,newClassLayer);

    %freeze weights (not used for best results)
%     layers = lgraph.Layers;
%     connections = lgraph.Connections;
%     layers(1:10) = freezeWeights(layers(1:10));
%     lgraph = createLgraphUsingConnections(layers,connections);

catch
    disp('error loading plain googlenet - reading from mat file')
    load('googlenet_xfer_plain.mat')
end

testImageStore = imageDatastore([mainPath specDir filesep 'test'],...
    'IncludeSubfolders',true,'FileExtensions','.png','LabelSource','foldernames')

atestImageStore = augmentedImageDatastore([224 224],testImageStore);

valImageStore = imageDatastore([mainPath specDir filesep 'val'],...
    'IncludeSubfolders',true,'FileExtensions','.png','LabelSource','foldernames')

avalImageStore = augmentedImageDatastore([224 224],valImageStore);

%Augment training data by flipping left/right
imageAugmenter = imageDataAugmenter( ...
    'RandXReflection', true);

trainImageStore = imageDatastore([mainPath specDir filesep 'train'],...
    'IncludeSubfolders',true,'FileExtensions','.png','LabelSource','foldernames')

atrainImageStore = augmentedImageDatastore([224 224],trainImageStore,'DataAugmentation',imageAugmenter);

% acc_9755 training options
options = trainingOptions('adam', ...
    'MiniBatchSize',10, ...
    'MaxEpochs',24, ...
    'InitialLearnRate',1e-4, ...
    'Shuffle','every-epoch', ...
    'ValidationData',avalImageStore, ...
    'ValidationFrequency',1542, ...
    'LearnRateSchedule','piecewise',...
    'LearnRateDropPeriod',6,...
    'LearnRateDropFactor',.5,...
    'Verbose',true, ...
    'CheckpointPath',checkpointPath, ...
    'Plots','training-progress');

net = trainNetwork(atrainImageStore,lgraph,options);

[YPred,probs] = classify(net,atestImageStore);
accuracy = mean(YPred == testImageStore.Labels)
auc = scoreAUC(testImageStore.Labels=='cars',probs(:,2))
