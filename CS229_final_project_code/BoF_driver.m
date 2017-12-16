%% run bag of features

close all; clear all; clc;
%%
rootFolder = fullfile(pwd, 'image_samples');
categories = {'positive','negative'};
imds = imageDatastore(fullfile(rootFolder, categories), 'LabelSource', 'foldernames');
tbl = countEachLabel(imds);
[trainingSet, validationSet] = splitEachLabel(imds, 0.75, 'randomize');

%%
extractorFcn = @SIFT_extractor;
Vsize=200;
bag = bagOfFeatures(trainingSet,'VocabularySize',Vsize,...
    'CustomExtractor',extractorFcn,'StrongestFeatures',1);

%%
larv = find(trainingSet.Labels == 'positive', 3);
nonlarv = find(trainingSet.Labels == 'negative', 3);

for i=1:3
    Larv=readimage(trainingSet,larv(i));
    featureVec_Larv=encode(bag, Larv);
    figure()
    subplot(1,2,1)
    imshow(Larv)
    subplot(1,2,2)
    bar(featureVec_Larv)
    title('Visual word occurrences')
    xlabel('Visual word index')
    ylabel('Frequency of occurrence')
end


for i=1:3
    Non_larv=readimage(trainingSet,nonlarv(i));
    featureVec_NL=encode(bag, Non_larv);
    figure()
    subplot(1,2,1)
    imshow(Non_larv)
    subplot(1,2,2)
    bar(featureVec_NL)
    title('Visual word occurrences')
    xlabel('Visual word index')
    ylabel('Frequency of occurrence')
end


%%
categoryClassifier = trainImageCategoryClassifier(trainingSet, bag);

%%
confMatrix = evaluate(categoryClassifier, trainingSet);
confMatrix = evaluate(categoryClassifier, validationSet);
%%

numTrainImages = numel(trainingSet.Files);
predictedLabels = zeros(numTrainImages,1);
for i = 1:numTrainImages
    img = readimage(trainingSet, i);
    predictedLabels(i) = predict(categoryClassifier, img);
end

% Get labels for each image.
trainingLabels = trainingSet.Labels;



targets=zeros(2,numTrainImages);
for i = 1:numTrainImages
    if (trainingSet.Labels(i) == 'positive')
       targets(:,i)=[1;0];
    else
       targets(:,i)=[0;1];
    end
      
end

outputs=zeros(2,numTrainImages);
for i = 1:numTrainImages
    if predictedLabels(i) == 2
       outputs(:,i)=[1;0];
    else
       outputs(:,i)=[0;1];
    end
      
end

plotconfusion(targets,outputs);
set(gca,'xticklabel',{'positive' 'negative' ''});
set(gca,'yticklabel',{'positive' 'negative' ''});



%%

numDevImages = numel(validationSet.Files);
predictedLabels = zeros(numDevImages,1);
for i = 1:numDevImages
    img = readimage(validationSet, i);
    predictedLabels(i) = predict(categoryClassifier, img);
end

% Get labels for each image.
DevLabels = validationSet.Labels;

targets=zeros(2,numDevImages);
for i = 1:numDevImages
    if (validationSet.Labels(i) == 'positive')
       targets(:,i)=[1;0];
    else
       targets(:,i)=[0;1];
    end
      
end

outputs=zeros(2,numDevImages);
for i = 1:numDevImages
    if predictedLabels(i) == 2
       outputs(:,i)=[1;0];
    else
       outputs(:,i)=[0;1];
    end
      
end

plotconfusion(targets,outputs);
set(gca,'xticklabel',{'positive' 'negative' ''});
set(gca,'yticklabel',{'positive' 'negative' ''});

