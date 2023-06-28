
clc
clear
close all

%
% Step 1/4
%

% Preprocessing Dataset script 

% SUMMARY
%
% dataset file structure:
% 
% 	audioData2:
% 		zero:
% 			0_01_0.wav
% 			0_01_1.wav
% 			...
% 		one:
% 			1_01_0.wav
% 			1_01_1.wav
% 			...
% 		two:
% 			...
% 		three:
% 			...
% 		four:
% 			...
% 		five
% 			...
% 
% The audio files are split in folders based on their 'class'.
% All folders are inside the folder 'audioData2'.
% 
% The script reads the audio files and performs the following steps
% for each one:
% 
% 	- normalize the original signal values to
% 	  interval [0, 1]
% 	  
% 	- change sampling Frequency to 8.000Hz
% 	
% 	- filter the signal with a highpass FIR filter
% 	
% 	- isolate the word inside the signal
% 	
% 	- store the result signal in cell array 'signals'
% 	  and it's class label to cell array 'labels'
%



% Short-term processing parameters
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


signals = {};   % cell array containing all resulting audio signals
labels = {};    % cell array containing cooresponing labels

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

        % if word isolation finds more than one
        % word, dismiss the signal
        if(length(single)>1)
            audioname
            length(single)
            continue;
        end
             
        signals{end+1} = single{1};
        labels{end+1} = folders{i};
    end
end


% check signal lenghts lengths...
allLengths = cellfun(@length, signals);
[maxLength, imax] = max(allLengths)
[minLength, imin] = min(allLengths)

labels= labels';

% store the cell arrays to .mat files

save augmentedDataset\augmentedDatasetLabelsV1.mat labels
save augmentedDataset\augmentedDatasetV1.mat signals


