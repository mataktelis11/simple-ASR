
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
load augmentedDataset\augmentedDatasetV1.mat
load augmentedDataset\augmentedDatasetLabelsV1.mat

% define length of feature vectors
featureLength = 8000;


% show some samples of the dataset as spectrograms
displaySpecNumber = 16;

signalIndexes = randperm(length(signals),displaySpecNumber);

displayDimension = sqrt(displaySpecNumber);

figure('Name','Training Images Sample');

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
    
%    sig = [signals{k} zeros(1,8000- length(signals{k}))];
%    
%    coeffs = spectrogram(sig,100,80,100,8000,'yaxis');
%    coeffs = abs(coeffs);
%    coeffs = reshape(coeffs.',1,[]);
%    size(coeffs);
   
   featureVectors{end+1} = extractFeatures(signals{k}, 8000, 1);
end


