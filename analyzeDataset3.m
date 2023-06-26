
clc
clear
close all

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


signals = {};
labels = {};

folders = dir('audioData2/*');
folders = {folders.name};
folders = folders(3:end); % for UNIX remove '.' and '..'


for i=1:length(folders)
   
    audifiles = dir(strcat('audioData2/',folders{i},'/*'));
    audifiles = {audifiles.name};
    audifiles = audifiles(3:end); % for UNIX remove '.' and '..'
    
    for file=1:length(audifiles)
        % read image
        audioname = strcat('audioData2/',folders{i},'/',audifiles{file});

        
        
        
        % load speech file
        [speech,FsOrig]=audioread(audioname);

        % normalize the original signal
        % so the values are in the interval [0, 1]
        speechMin=min(speech);
        speechMax=max(speech);
        speech=speech/max(speechMax,-speechMin);

        % resample the signal
        x=resample(speech,Fs,FsOrig);

        % filter the resampled signal with a FIR bandpass filter
        x=filter(filt,1,x);

        single = isolateWords(x,Fs,w,h,10,35,0);

        if(length(single)>1)
            audioname
            length(single)
            continue;
        end
             
        signals{end+1} = single{1};
        labels{end+1} = folders{i};
    end
end


% check lengths...
allLengths = cellfun(@length, signals);
[maxLength, imax] = max(allLengths)
[minLength, imin] = min(allLengths)

labels= labels';


% soundsc(signals{1},Fs)

