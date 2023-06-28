function [Y,pitch] = numbersASR(speech, FsOrig, model, visualize)
%NUMBERSASR Detects words in a audio speech signal
%
%   This script simulates the process of an Automatic Speech Recognition
%   System. More specifically, the following steps are implemented:
%
%   1. change sample rate to 8.000Hz
%   2. highpass FIR filter
%   3. isolate each word in the signal with a foreground vs background
%      classifier
%   4. calculate the fundamental frequency of each word
%   5. estimate which words are in the signal with a trained SVM model
%
%   Args:
%       speech:     the audio speech signal
%       FsOrig:     the sampling frequency of the signal
%       model:      the SVM trained model to detect words
%       visualize:  0 or 1
%                   0 : do not display diagrams
%                   1 : display diagrams 
%
%
%   Returns:
%       Y:      matrix containing the names of the predicted classes
%               of each word
%
%       pitch:  pitch of each word
%
%
%
% Example 1:
% 
%   load trainedModelsCompact\svmClassifierV0.mat;
%
%   [speech,FsOrig]=audioread('samples/3rec.wav');
% 
%   [Y,pitch] = numbersASR(speech,FsOrig,SVMClassifierCompact,1)
%
%
%
% Example 2:
%
%   r = audiorecorder(44100,16,1);
%   record(r) % speak into microphone
%   stop(r)
%   p = play(r); % listen
%
%   speech = getaudiodata(r);
%
%   load trainedModelsCompact\svmClassifierV0.mat;
%
%   [Y,pitch] = numbersASR(speech,44100,SVMClassifierCompact,0)
%

%%%% PROGRAM PARAMETERS %%%%

% these parameters have also been used for the model

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

% normalize the original signal
% so the values are in the interval [0, 1]
speechMin=min(speech);
speechMax=max(speech);
speech=speech/max(speechMax,-speechMin);

% resample the signal
x = resample(speech,Fs,FsOrig);
% alternative function
%x = srcInterpolation(speech, FsOrig, Fs);

% filter the resampled signal with a FIR bandpass filter
filt = firpm(order, F, Ws);
x=filter(filt,1,x);

% find words inside the signal
isolatedWords = isolateWords(x,Fs,w,h,10,35,visualize);

Y = strings([1,length(isolatedWords)]);
pitch = zeros(1, length(isolatedWords), 'double');

for k=1:length(isolatedWords)

    if(visualize==1)
        figure('Name', ['Word# ' num2str(k)])
        subplot(2,3,3)       
    end
    
    % calculate pitch        
    freq = pitchTracking(isolatedWords{k},Fs,visualize);
    
    if(visualize==1)
        title('Autocorrelation of word')   
        subplot(2,3,[1 2 4 5])        
    end
     
    % extract feature vector and pass to SVM to predict class
    featureVector = extractFeatures(isolatedWords{k}, 8000, visualize);       
    prediction = predict(model, featureVector);
    prediction = cell2mat(prediction);
    prediction = convertCharsToStrings(prediction);
   
   if(visualize==1)
       title('Spectrogram of word')
       subplot(2,3,6)
       s = strcat('Pitch: ', num2str(freq), 'Hz, class = ',prediction);
       text(0,0.5,s); axis off
       set(gcf,'Position',[100 100 1000 400])
   end
    
    
    Y(k) = prediction;
    pitch(k) = freq;
end

end

