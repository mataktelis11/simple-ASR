
% ASR script
%   Detecting words in a audio speech signal
%
% This script simulates the process of an Automatic Speech Recognition
% System. More specifically, the following steps are implemented:
%
%   1. change sample rate to 8.000Hz
%   2. highpass FIR filter
%   3. isolate each word in the signal with a foreground vs background
%      classifier
%   4. calculate the fundamental frequency of each word
%   5. estimate which words are in the signal with a trained SVM model
%
% There are pretrained models inside the folder 'trainedModelsCompact'.
%
%
%       svmClassifierV0: detects words {'zero', 'one', 'two', 'three', 
%                                       'four', 'five'}
%
%
%
%
% There are also some audio samples for testing in the folder 'samples'.
%
% This script is also provided as a function: 'numbersASR'.
% Type 'help numbersASR' in the Matlab cmd for more.
%
% If you want to train your own model run the following scripts in this
% order:
%       1. preprocess_dataset_script.m
%       2. feature_extraction_script.m
%       3. SVM_training_script.m
%       4. SVM_evaluation_script.m
%
% Aristotelis Matakias - Summer 2023
% Course: Speech and Audio Processing
%

% clear command line, variables and close all figures
clc
clear
close all

%%%% USER DEFINED PARAMETERS %%%%

audioFilename = 'samples/record1.wav';

visualize = 1;  % 0 : do not display diagrams
                % 1 : display diagrams (slower)

playWords = 1;  % 0 : do not play each detected word with 1s delay
                % 1 : play detected words               

useFIRfilter = 1;  % 0 : do not use FIR filter
                   % 1 : use FIR filter

% choose trained SVM
load trainedModelsCompact\svmClassifierV0.mat;
%load trainedModelsCompact\svmClassifierV1.mat;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%% PROGRAM PARAMETERS %%%%

% these parameters have also been used for training the model

w = 30;         % Frame Duration in ms
h = 10;         % Frame Shift in ms

Fs = 8000;      % Sampling Frequency after downsample

% FIR parameters (firpm)
% stopband:         0-100 Hz
% transition band:  100-200 Hz
% pass-band:        200-4000 Hz
order = 30;
F = [0 100 200 Fs/2]/(Fs/2);
Ws = [0 0 1 1];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% load speech file
[speech,FsOrig]=audioread(audioFilename);

% normalize the original signal
% so the values are in the interval [0, 1]
speechMin=min(speech);
speechMax=max(speech);
speech=speech/max(speechMax,-speechMin);

% resample the signal
x=resample(speech,Fs,FsOrig);

% filter the resampled signal with a FIR bandpass filter
filt = firpm(order, F, Ws);
if(useFIRfilter==1)
    x=filter(filt,1,x);
end

% find words inside the signal
isolatedWords = isolateWords(x,Fs,w,h,10,35,visualize);

% play the words
if(playWords==1)
    soundWords = [];  
    for k=1:length(isolatedWords)
        soundWords = [soundWords isolatedWords{k} zeros(1,Fs)];
    end
    soundsc(soundWords,Fs);
end

% calculate the Fundamental Frequency (Pitch) for each word
for k=1:length(isolatedWords)
    
    if(visualize==1)
        figure('Name', ['Word# ' num2str(k)])
        subplot(2,3,3)       
    end
    
   freq = pitchTracking(isolatedWords{k},Fs,visualize);
    
    if(visualize==1)
        title('Autocorrelation of word')   
        subplot(2,3,[1 2 4 5])        
    end
    
   % extract feature vector and pass to SVM to predict class
   featureVector = extractFeatures(isolatedWords{k}, 8000, visualize);            
   prediction = predict(SVMClassifierCompact, featureVector);
   prediction = cell2mat(prediction);
   prediction = convertCharsToStrings(prediction);
      
   if(visualize==1)
       title('Spectrogram of word')
       subplot(2,3,6)
       s = strcat('Pitch: ', num2str(freq), 'Hz, class = ',prediction);
       text(0,0.5,s); axis off
       set(gcf,'Position',[100 100 1000 400])
   end
   
   
   fprintf('Detected word#%d: pitch = %f, class = %s\n',k,freq,prediction);
   
   
end


