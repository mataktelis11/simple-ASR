% number analyzer script

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

hpforder=30;                % order of highpass filter  
lowcut=100;                 % low band reject frequency   (Hz)
highcut=200;                % high band cut-off frequency (Hz)
                            % transition between lowcut-highcut

Fs = 8000;

% load speech file
[speech,FsOrig]=audioread('ZA.waV');

% normalize the original signal
% so the values are in the interval [0, 1]
speechMin=min(speech);
speechMax=max(speech);
speech=speech/max(speechMax,-speechMin);

% resample the signal
x=resample(speech,Fs,FsOrig);

hpfilter=firpm(hpforder,[0 lowcut highcut Fs/2]/(Fs/2),[0 0 1 1]);
y=filter(hpfilter,1,x);

coeff = specgram(y,NFFT,Fs,WINDOW,NOVERLAP);


figure('Name','Word Analysis')
specgram(y,NFFT,Fs,WINDOW,NOVERLAP);

