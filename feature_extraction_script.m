
clc
clear
close all

%
% Step 2/4
%

% Feature extraction script

% SUMMARY
% 
% This script extracts the feature vectors of
% the saved augmented dataset.
% The feature vectors are loaded in a cell array.
%


% load the augmented dataset
load augmentedDataset\augmentedDataset.mat
load augmentedDataset\augmentedDatasetLabels.mat

% define length of feature vectors
featureLength = 8000;


% show some samples of the dataset as spectrograms
displaySpecNumber = 16;

signalIndexes = randperm(length(signals),displaySpecNumber);

displayDimension = sqrt(displaySpecNumber);

figure('Name','Training Spectrograms Sample');

for i=1:displaySpecNumber
    subplot(displayDimension,displayDimension,i);
    index = signalIndexes(i);
    extractFeatures(signals{index}, 8000, 1);
    title( strcat(num2str(index),'/',labels(index)))
end


% save all feature vectors in a cell array

featureVectors = {};

sig = zeros(1,featureLength);

for k=1:length(signals)
   featureVectors{end+1} = extractFeatures(signals{k}, 8000, 0);
end


