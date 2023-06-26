%

clc
clear
close all

% Filter 1 (source: exercise 10.4)

% sample rate:      8000 Hz
% stopband:         0-100 Hz
% transition band:  100-200 Hz
% pass-band:        200-4000 Hz

Fs = 8000;
f1 = firpm(100,[0 100 200 Fs/2]/(Fs/2),[0 0 1 1]);


audioFilename = 'samples/3rec.wav';

% load speech file
[speech,FsOrig]=audioread(audioFilename);

% normalize the original signal
% so the values are in the interval [0, 1]
speechMin=min(speech);
speechMax=max(speech);
speech=speech/max(speechMax,-speechMin);

% resample the signal
x=resample(speech,Fs,FsOrig);

x1 = filter(f1,1,x);

% Filter 2 (source: exercise 10.7)

% sample rate:     10000 Hz
% stopband from 0 to 80 Hz
% transition band from 80 to 150 Hz
% passband from 150 to 900 Hz
% transition band from 900 to 970 Hz









