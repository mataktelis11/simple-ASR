
clc
clear
close all

% Feature extraction script

% load the augmented dataset
load augmentedDataset\augmentedDatasetV1.mat

% define length of feature vectors
featureLength = 8000;

featureVectors = {};

sig = zeros(1,featureLength);

for k=1:length(signals)
    
   sig = [signals{k} zeros(1,8000- length(signals{k}))];
   
   coeffs = spectrogram(sig,100,80,100,8000,'yaxis');
   coeffs = abs(coeffs);
   coeffs = reshape(coeffs.',1,[]);
   size(coeffs);
   
   featureVectors{end+1} = coeffs;
end


