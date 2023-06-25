clc
clear
close all

audioFilename = 'samples/3rec.wav';
w = 30;
h = 10;
Fs = 8000;


% load speech file
[speech,FsOrig]=audioread(audioFilename);

% normalize the original signal
% so the values are in the interval [0, 1]
speechMin=min(speech);
speechMax=max(speech);
speech=speech/max(speechMax,-speechMin);

% resample the signal
x=resample(speech,Fs,FsOrig);






%w                      % moving window length in ms
winlength=w*Fs/1000;       % moving window length (in samples).
%h                     % hop size in ms
winstep=h*Fs/1000;         % hop size in samples

N = length(x); % signal length



if(mod(N-winlength,winstep)~=0)

    extra_samples = winstep - mod(N-winlength,winstep);
    x = [x ; zeros(extra_samples,1)];
    
end

N = length(x); % new signal length

numOfFrames = (N - winlength)/winstep + 1;

Energy = zeros(1,numOfFrames,'double');
ZeroCrossRate = zeros(1,numOfFrames,'double');




for m=0:numOfFrames-1
    a = m*winstep+1;
    b = m*winstep+winlength;
    frame = x(m*winstep+1:m*winstep+winlength);


    w = hamming(winlength);
    
    Energy(m+1) = 10*log10(sum((frame.*w).^2));

    
    absValues = abs(diff(sign(frame)));
    absValues(absValues==1) = 2;
    ZeroCrossRate(m+1) = sum(absValues);
    ZeroCrossRate(m+1) = ZeroCrossRate(m+1)*winstep/(2*winlength);
    
end




figure('Name', 'Short-Term processing')

subplot(311)
stem(x)
%maxAmpl=max(abs(y));
%axis([1 totalFrames*R -abs(maxAmpl) abs(maxAmpl)])
xlabel('Sample')
ylabel('Amplitude')
title(['High Pass Filtered Resampled Speech Signal'])
grid on
hold on

subplot(312)
stem(Energy)
hold on
%axis([1 totalFrames min(energy) max(energy)])
xlabel('Frame')
ylabel('Energy')
title(['Logarimthmic Energy of Each Frame of speech signal'])
grid on

subplot(313)
stem(ZeroCrossRate)
hold on
%axis([1 totalFrames 0 50])
xlabel('Frame')
ylabel('Zerocrossings')
title(['Zerocrossings of Each Frame of speech signal'])
grid on



trainingFrames=10;              
eavg=mean(Energy(1:trainingFrames))
esig=std(Energy(1:trainingFrames))
zcavg=mean(ZeroCrossRate(1:trainingFrames))
zcsig=std(ZeroCrossRate(1:trainingFrames))


IF = 35                       % Constant Zero Crossing Threshold         
IZCT = max(IF,zcavg+3*zcsig)  % Variable Zero Crossing Threshold

IMX = max(Energy)             % Max Log Energy
ITU = IMX-20                  % High Log Energy Threshold
ITL = max(eavg+3*esig, ITU-10)% Low Log Energy Threshold

% Classification

classification = zeros(1, numOfFrames);

for fr=1:numOfFrames

    % Apply decision threshold

    if Energy(1,fr) >= ITU && ZeroCrossRate(1,fr) <= IZCT 
        classification(1, fr) = 2; % Class 2 (foreground)
    else
        classification(1, fr) = 1; % Class 1 (background)
    end
end

% Highlight speech frames
foregroundFrames = find(classification == 2);
xline(foregroundFrames, 'g');

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



stem(x)
xlabel('Sample')
ylabel('Amplitude')
title(['Resmpled Speech Signal - Fs=' num2str(Fs) 'Hz with FIR'])
grid on
hold on

soundWords = [];
isolatedWords = {};

for k=1:length(words)
    word = words{k};

    firstSample = word(1)*winstep;
    lastSample = word(end)*winstep+winlength-1;
    xline(firstSample, 'g');
    xline(lastSample, 'r');

    stem(firstSample:lastSample, x(firstSample:lastSample),'r')

    soundWord = x(firstSample:lastSample);
    soundWords = [soundWords soundWord' zeros(1,4000)];
    isolatedWords{end+1} = soundWord';
end

soundsc(soundWords,Fs); % play the isolated words with a pause



