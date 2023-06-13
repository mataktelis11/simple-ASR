% Word predictor script

% Summary
% 
% 
%
%
%
%
% Aristotelis Matakias - Summer 2023

% USER DEFINED PARAMETERS:

NFFT=32;
WINDOW=32;
NOVERLAP=16;

% assuming 'Fs' and words in cell array 'isolatedWords'

wordSignal = isolatedWords{4};

% compute the feature vector

coeff = specgram(wordSignal,NFFT,Fs,WINDOW,NOVERLAP);

featureVector = abs(coeff);
% flatten
featureVector = reshape(featureVector.',1,[]);
% zero padding (this will be a parameter)
featureVector = [featureVector zeros(1,8500-length(featureVector))];

figure('Name','Word Spectogram')
specgram(wordSignal,NFFT,Fs,WINDOW,NOVERLAP);




% Load the saved SVM model
loadedModel = load('trainedModel.mat');

% Access the loaded SVM model
svmModel = loadedModel.svmModel;

prediction = predict(svmModel, featureVector)



