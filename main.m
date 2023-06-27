

%clc
%clear
close all

%%%% USER DEFINED PARAMETERS %%%%

audioFilename = 'samples/1A.waV';

visualize = 0;  % 0 : do not display diagrams
                % 1 : display diagrams (slower)

playWords = 1;  % 0 : do not play each detected word with 1s delay
                % 1 : play detected words               

useFIRfilter = 1;  

if exist('SVMClassifier','var') == 0
    load trainedModels\thos.mat;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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
    freq = pitchTracking(isolatedWords{k},Fs,visualize,['Autocorrelation of word# ' num2str(k)])
%     figure
%     pitch(isolatedWords{k}',Fs)
end


for k=1:length(isolatedWords)
    
    
    sig = [isolatedWords{k} zeros(1,8000- length(isolatedWords{k}))];
    
   coeffs = spectrogram(sig,100,80,100,8000,'yaxis');
   coeffs = abs(coeffs);
   coeffs = reshape(coeffs.',1,[]);
   
   prediction = predict(tinyModel, coeffs)
   
end


