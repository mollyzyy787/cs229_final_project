% run E-SVM for HOG

close all; clear all; clc;
%%
rootFolder = fullfile(pwd, 'image_samples');
categories = {'positive','negative'};
imds = imageDatastore(fullfile(rootFolder, categories), 'LabelSource', 'foldernames');
tbl = countEachLabel(imds);
[trainingSet, validationSet] = splitEachLabel(imds, 0.8, 'randomize');


%%
p1 = find(trainingSet.Labels == 'positive', 1);
n1 = find(trainingSet.Labels == 'negative', 1);

p1_im=readimage(trainingSet,p1);
p1_im=imresize(p1_im,[50 50]);
[hogp,visp] = extractHOGFeatures(p1_im,'CellSize',[5 5]);

n1_im=readimage(trainingSet,n1);
n1_im=imresize(n1_im,[50 50]);
[hogn,visn] = extractHOGFeatures(n1_im,'CellSize',[5 5]);


figure()
subplot(1,2,1)
imshow(n1_im); hold on;
plot(visn);
subplot(1,2,2)
imshow(p1_im); hold on;
plot(visp);
%%
hogFeatureSize=length(hogp);
cellsize=[5 5];
%%



PosTrain_ind = find(trainingSet.Labels == 'positive');
numPosTrain = length(PosTrain_ind);
NegTrain_ind = find(trainingSet.Labels == 'negative');
numNegTrain = length(NegTrain_ind);

trainingPosFeatures=zeros(numPosTrain,hogFeatureSize);
trainingNegFeatures=zeros(numNegTrain,hogFeatureSize,numPosTrain);

%%
numImages = numel(trainingSet.Files);
ALLtrainingFeatures = zeros(numImages, hogFeatureSize, 'single');

for i = 1:numImages
    img = readimage(trainingSet, i);
    img = imresize(img,[50 50]);

    img = rgb2gray(img);

    ALLtrainingFeatures(i, :) = extractHOGFeatures(img, 'CellSize', [5 5]);
end

% Get labels for each image.
ALLtrainingLabels = trainingSet.Labels;

%%

classifiers = cell(numPosTrain,1);
ScoreSVMModel = cell(numPosTrain,1);
for i=1:numPosTrain
    TrainingLabels=zeros(1+numNegTrain,1);
    TrainingLabels(1) = trainingSet.Labels(PosTrain_ind(1));
    p=readimage(trainingSet, PosTrain_ind(i));
    p=imresize(p,[50 50]);
    p=rgb2gray(p);  
    trainingPosFeatures(i,:)=extractHOGFeatures(p, 'CellSize', cellsize);
    for j=1:numNegTrain
        n=readimage(trainingSet, NegTrain_ind(j));
        n=imresize(n,[50 50]);
        n=rgb2gray(n);
        trainingNegFeatures(j,:,i)=extractHOGFeatures(n,'CellSize',cellsize);
        TrainingLabels(1+j)=trainingSet.Labels(NegTrain_ind(j));
    end
    TrainingFeatures=[trainingPosFeatures(i,:);
                      trainingNegFeatures(:,:,i)];
    classifier = fitcsvm(TrainingFeatures,TrainingLabels);
    held_outFeature=ALLtrainingFeatures;
    held_outFeature(PosTrain_ind(i),:)=[];
    held_outLabel=ALLtrainingLabels;
    held_outLabel(PosTrain_ind(i))=[];
    classifiers{i} = classifier;
    ScoreSVMModel{i} = fitSVMPosterior(classifier,held_outFeature,held_outLabel);
end

%% combining E-SVMs
predictedLabels=zeros(numImages,1);
for i= 1:numImages
    label=zeros(numPosTrain,1);
    overlap=0;
    for j=1:numPosTrain
        label(j)=predict(ScoreSVMModel{j},ALLtrainingFeatures(i,:));
        if label(j)== 2
            overlap=overlap+1;
        else
            overlap=overlap;
        end
    end
    if overlap >= 1
        predictedLabels(i)= 2;
    else
        predictedLabels(i)= 1;
    end
end

targets=zeros(2,numImages);
for i = 1:numImages
    if (trainingSet.Labels(i) == 'positive')
       targets(:,i)=[1;0];
    else
       targets(:,i)=[0;1];
    end
      
end

outputs=zeros(2,numImages);
for i = 1:numImages
    if (predictedLabels(i) == 2 )
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

ALLDevFeatures=zeros(numDevImages,hogFeatureSize);
for i = 1:numDevImages
    img = readimage(validationSet, i);
    img = imresize(img,[50 50]);

    img = rgb2gray(img);

    ALLDevFeatures(i, :) = extractHOGFeatures(img, 'CellSize', [5 5]);
end

% Get labels for each image.
ALLDevLabels = validationSet.Labels;

for i= 1:numDevImages
    label=zeros(numPosTrain,1);
    overlap=0;
    for j=1:numPosTrain
        label(j)=predict(ScoreSVMModel{j},ALLDevFeatures(i,:));
        if label(j)== 2
            overlap=overlap+1;
        else
            overlap=overlap;
        end
    end
    if overlap >= 1
        predictedLabels(i)= 2;
    else
        predictedLabels(i)= 1;
    end
end

% Get labels for each image.
DevLabels = validationSet.Labels;
%%
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
    if (predictedLabels(i) == 2 )
       outputs(:,i)=[1;0];
    else
       outputs(:,i)=[0;1];
    end
      
end

plotconfusion(targets,outputs);
set(gca,'xticklabel',{'positive' 'negative' ''});
set(gca,'yticklabel',{'positive' 'negative' ''});