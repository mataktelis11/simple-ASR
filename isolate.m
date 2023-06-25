
clc
clear
%close all

% Simple Isolated Word Detector script

% Summary
% 
% This script reads an audio file that contains human speech.
% The audio file is analyzed and all the words are isolated and
% extracted. It works by classifying each frame as a background frame
% (class 1) or a foreground frame (class 2).
%
% The steps implemented:
%
%   1. resampling to 8000 Hz
%   2. highpass filtering 
%   3. Calculate Detection Parameters
%   4. Classification of frames
%   5. Word extraction
%
%
% Based on exercise 10.4 of book:
% Theory and Applications of 
% Digital Speech Processing, L.R. Rabiner, R.W. Schafer
% ISBN:0136034284
%
% Aristotelis Matakias - Summer 2023
% Course: Speech and Audio Processing
% 



%%%% USER DEFINED PARAMETERS %%%%

audioFilename = 'samples/3rec.wav';

Fs=8000;                    % Sampling Frequency after downsample
nfft=1024;                  % fft length used in spectral calculations

hpforder=30;                % order of highpass filter  
lowcut=100;                 % low band reject frequency   (Hz)
highcut=200;                % high band cut-off frequency (Hz)
                            % transition between lowcut-highcut
% step 4
NS=30;                      % Frame Duration in ms
L=NS*Fs/1000;               % Frame Duration in samples
MS=10;                      % Frame Shift in ms
R=MS*Fs/1000;               % Frame Shift in samples


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


figure('Name','Preprocessing')

subplot(221)
stem(speech)
xlabel('Sample')
ylabel('Amplitude')
title(['Original Signal - Fs=' num2str(FsOrig) 'Hz'])
grid on

subplot(223)
stem(x)
xlabel('Sample')
ylabel('Amplitude')
title(['Resmpled Speech Signal - Fs=' num2str(Fs) 'Hz'])
grid on

subplot(222)
[Sspeech,f]=freqz(speech,1,1024,FsOrig);
plot(f,20*log10(abs(Sspeech)))
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)')
title(['Original Speech Signal Spectrum with Fs=' num2str(FsOrig) 'Hz'])
grid on

subplot(224)
[Sx,f]=freqz(x,1,1024,Fs);
plot(f,20*log10(abs(Sx)))
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)')
title(['Resampled Speech Signal Spectrum with new Fs=' num2str(Fs) 'Hz'])
grid on


% highpass filtering 
% Band reject 0-100Hz
% Band transition 100-200Hz
% Bandpass 100-4000Hz
hpfilter=firpm(hpforder,[0 lowcut highcut Fs/2]/(Fs/2),[0 0 1 1]);
y=filter(hpfilter,1,x);

figure('Name','Filtering')
subplot(311)
[Sx,f]=freqz(x,1,1024,Fs);
plot(f,20*log10(abs(Sx)))
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)')
title(['Resampled Speech Signal and High Pass filter response'])
grid on
hold on
[HP,f]=freqz(hpfilter,1,1024,Fs);
plot(f,20*log10(abs(HP)),'r')

subplot(312)
[Sy,f]=freqz(y,1,1024,Fs);
plot(f,20*log10(abs(Sy)))
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)')
title(['High Pass Filtered Resampled Speech Signal Spectrum'])
grid on

subplot(313)
stem(y)
xlabel('Sample')
ylabel('Amplitude')
title(['High Pass Filtered Resampled Speech Signal'])
grid on


% Step
% Calculate Short-Term Logarithmic Energy and 
% Zero Crossing rate for each frame

totalSamples=length(y);
ss=1;
energy=[];
zerocrossings=[];
% retrieve frames from speech signal y 
while (ss+L-1 <= totalSamples)
    frame=y(ss:ss+L-1).*hamming(L);
    energy=[energy 10*log10(sum(frame.^2))];
    zerocrossings=[zerocrossings sum(abs(diff(sign(frame))))];
    ss=ss+R;
end
totalFrames=length(energy);
zerocrossings=zerocrossings*R/(2*L);

figure('Name', 'Short-Term processing')

subplot(311)
stem(y)
maxAmpl=max(abs(y));
axis([1 totalFrames*R -abs(maxAmpl) abs(maxAmpl)])
xlabel('Sample')
ylabel('Amplitude')
title(['High Pass Filtered Resampled Speech Signal'])
grid on
hold on

subplot(312)
stem(energy)
hold on
axis([1 totalFrames min(energy) max(energy)])
xlabel('Frame')
ylabel('Energy')
title(['Logarimthmic Energy of Each Frame of speech signal'])
grid on

subplot(313)
stem(zerocrossings)
hold on
axis([1 totalFrames 0 50])
xlabel('Frame')
ylabel('Zerocrossings')
title(['Zerocrossings of Each Frame of speech signal'])
grid on

%% Calculate average and standard deviation 
%% of energy and zerocrossing for background signal
%% e.g first 10 frame of signal
trainingFrames=10;              %% first 10 frames 
eavg=mean(energy(1:trainingFrames))
esig=std(energy(1:trainingFrames))
zcavg=mean(zerocrossings(1:trainingFrames))
zcsig=std(zerocrossings(1:trainingFrames))


% Calculate Detection Parameters
IF=35                       %% Constant Zero Crossing Threshold         
IZCT=max(IF,zcavg+3*zcsig)  %% Variable Zero Crossing Threshold
                            %% Depends on Training
IMX=max(energy)             %% Max Log Energy
ITU=IMX-20                  %% High Log Energy Threshold
ITL=max(eavg+3*esig, ITU-10)%% Low Log Energy Threshold

% figure('Name', 'threshold')
% subplot(312)
% plot(1:totalFrames,ITU*ones(totalFrames),'g')
% plot(1:totalFrames,ITL*ones(totalFrames),'g')
% title(['Logarimthmic Energy of Each Frame of speech signal and Thresholds'])
% hold on
% 
% subplot(313)
% plot(1:totalFrames,IZCT*ones(totalFrames),'g')
% title(['Zerocrossings of Each Frame of speech signal and Threshold'])
% hold on


% Classification

classification = zeros(1, totalFrames);

for fr=1:totalFrames

    % Apply decision threshold

    if energy(1,fr) >= ITU && zerocrossings(1,fr) <= IZCT 
        classification(1, fr) = 2; % Class 2 (foreground)
    else
        classification(1, fr) = 1; % Class 1 (background)
    end
end


% Highlight speech frames
foregroundFrames = find(classification == 2);
for i = 1:length(foregroundFrames)
    xline(foregroundFrames(i), 'g');
end


% Post Processing

classification2 = medfilt1(classification,10);
classification2(classification2 > 1) = 2;

figure('Name', 'Post processing')
subplot(311)
stem(classification)

subplot(312)
stem(medfilt1(classification,10))

subplot(313)
stem(classification2)




% word extraction

foregroundFrames = find(classification2 == 2);

previous = foregroundFrames(1);
frameStart = foregroundFrames(1);

words = {};

for i = 2:length(foregroundFrames)

    if foregroundFrames(i)-1 ~= previous
        frameEnd = previous;
        [frameStart:frameEnd]
        words{end + 1} = [frameStart:frameEnd];
        frameStart = foregroundFrames(i);
    end

    if i==length(foregroundFrames)
        frameEnd = foregroundFrames(end);
        [frameStart:frameEnd] % debug
        words{end + 1} = [frameStart:frameEnd];
        frameStart = foregroundFrames(i);
    end

    previous = foregroundFrames(i);
        
end

figure('Name', 'Isolated words')



stem(y)
xlabel('Sample')
ylabel('Amplitude')
title(['Resmpled Speech Signal - Fs=' num2str(Fs) 'Hz with FIR'])
grid on
hold on

soundWords = [];
isolatedWords = {};

for k=1:length(words)
    word = words{k};

    firstSample = word(1)*R;
    lastSample = word(end)*R+L-1;
    xline(firstSample, 'g');
    xline(lastSample, 'r');

    stem(firstSample:lastSample, y(firstSample:lastSample),'r')

    soundWord = y(firstSample:lastSample);
    soundWords = [soundWords soundWord' zeros(1,4000)];
    isolatedWords{end+1} = soundWord';
end

soundsc(soundWords,Fs); % play the isolated words with a pause
                        % NOTE: the sound is played from the edited signal
                        % (subsampled and filtered) so it will sound 
                        % different and faster

% visualize the isolated words on the samples

% 
% 
% figure('Name', 'Isolated words')
% 
% stem(x)
% xlabel('Sample')
% ylabel('Amplitude')
% title(['Resmpled Speech Signal - Fs=' num2str(Fs) 'Hz'])
% grid on
% hold on
% 
% %
% 
% for i = 1:length(foregroundFrames)
%     frameIndex = foregroundFrames(i);
% 
%     frameStart = frameIndex*R;
%     frameEnd = frameIndex*R + L -1;
% 
%         
%     xline([frameStart:frameEnd], 'g');
%         
% end






