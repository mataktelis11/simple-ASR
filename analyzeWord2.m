
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
filt = firpm(order, F, Ws);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





% load speech file
[speech,FsOrig]=audioread('dataset/04/4_43_33.wav');

% normalize the original signal
% so the values are in the interval [0, 1]
speechMin=min(speech);
speechMax=max(speech);
speech=speech/max(speechMax,-speechMin);

% resample the signal
x=resample(speech,Fs,FsOrig);

% filter the resampled signal with a FIR bandpass filter
x=filter(filt,1,x);

single = isolateWords(x,Fs,w,h,10,35,1);



