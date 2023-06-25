

clc
clear
close all

%%%% USER DEFINED PARAMETERS %%%%

audioFilename = 'samples/3rec.wav';

w = 30;         % Frame Duration in ms
h = 10;         % Frame Shift in ms
Fs = 8000;      % Sampling Frequency after downsample

visualize = 0;  % 0 : do not display diagrams
                % 1 : display diagrams (slower)

playWords = 1;  % 0 : do not play each detected word with 1s delay
                % 1 : play detected words               

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
    freq = pitchTracking(isolatedWords{k},Fs,1,['Autocorrelation of word# ' num2str(k)])
%     figure
%     pitch(isolatedWords{k}',Fs)
end





