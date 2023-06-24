
% Sample Rate Convarsion (SRC) demo script


% SUMMARY
%
% This script demonstrates the methods implemented to change the sample rate
% of a 1D signal. More specifically, it is assumed that the signal needs to
% be resampled by a rational factor p/q (where p and q are integers).
%
% Our input signal has a sampling frequency of 441000 Hz. We want to
% reduce this to 8000 Hz. This means the resampled factor is a non integer
% number. There are two known approaches:
%
%      1. Generate an intermediate signal by inserting p − 1 zeros between 
%         each of the original samples. Low-pass filter this signal at half
%         of the lower of the two rates. Select every q-th sample from the 
%         filtered output, to obtain the result.
%
%      2. Treat the samples as geometric points and create any needed new
%         points by interpolation. Many interpolation methods can be used.
%
% Method 1 is probably used by Matlab's 'resample' function. A custom
% function is provided (srcLowPassFilter) that implements method 1. It is
% noted that this method is very slow, escpecialy if the length of the
% signal is big. It is likely that Matlab's 'resample' function does some
% optimization.
%
% Method 2 is also implemented in the provided function 'srcInterpolation'.
% It utilizes Matlab's 'interp1' function, and unlike the previous
% function, it is very fast.
%
% 
% This script uses all the above fuctions to resample an audio signal from
% 44.1 kHz to 8 kHz. The commands 'tic' and 'toc' are used to calculate the
% elapsed time foreach function.
%
% Aristotelis Matakias - Summer 2023
% Course: Speech and Audio Processing


% clear cmd, variables, close all figures
clc
clear
close all

% load a speech signal
[sig,FsOrig]=audioread('samples/2.wav');


% we want to resample the signal to frequency Fs = 8000 Hz
Fs = 8000;

tic
% Method 1: use built in 'resample' function
sig1 = resample(sig, Fs, FsOrig);
t1 = toc;

tic
% Method 2: use 'srcLowPassFilter' function
sig2 = srcLowPassFilter(sig, FsOrig, Fs);
t2 = toc;

tic
% Method 3: use 'srcInterpolation'
sig3 = srcInterpolation(sig, FsOrig, Fs);
t3 = toc;

% plot all signals
figure('Name', 'Resampling functions')

subplot(411)
stem(sig)
title(['Original signal FsOrig = ' num2str(FsOrig)])

subplot(412)
stem(sig1)
title(['Resampled signal Fs = ' num2str(Fs) ' - resample function - time elapsed: ' num2str(t1)])

subplot(413)
stem(sig2)
title(['Resampled signal Fs = ' num2str(Fs) ' - srcLowPassFilter function - time elapsed: ' num2str(t2)])

subplot(414)
stem(sig3)
title(['Resampled signal Fs = ' num2str(Fs) ' - srcInterpolation function - time elapsed: ' num2str(t3)])

% play all signals
fprintf("Press any key to play the original signal\n")
pause
soundsc(sig, FsOrig);
fprintf("playing original signal ...\n")

fprintf("Press any key to play sig1\n")
pause
soundsc(sig1, Fs);
fprintf("playing sig1 ...\n")

fprintf("Press any key to play sig2\n")
pause
soundsc(sig2, Fs);
fprintf("playing sig2 ...\n")

fprintf("Press any key to play sig3\n")
pause
soundsc(sig3, Fs);
fprintf("playing sig3 ...\n")



