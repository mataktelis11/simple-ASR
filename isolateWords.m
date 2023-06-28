function [isolatedWords] = isolateWords(x,Fs,w,h,trainingFrames,IF,visualize)
%ISOLATEWORDS Return the words contained in a speech signal
%
%   This function reads an audio file that contains human speech.
%   The audio file is analyzed and all the words are isolated and
%   extracted. It works by classifying each frame as a background frame
%   (class 1) or a foreground frame (class 2).
%
%   The classification relies on the Energy and Zerocrossing rate of the
%   input signal. A hamming window is used for the short term processing.
%
%   Args:
%       x:  input speech signal (1xN dimentions)
%       Fs: sample rate of speech signal
%       w:  moving window length in ms
%       h:  hop size in ms
%       trainingFrames: number of frames used for the calvulation of mean
%           and stv of Energy and zerocrossing rate
%       IF: Constant Zero Crossing Threshold 
%       visualize: integer (0 or 1)% 0 : do not display diagrams
%                                    1 : display diagrams 
%
%   Returns:
%       isolatedWords: cell array containing the arrays cooresponding to
%                      the words of the input signal.
%
%
%
% Based on exercise 10.4 of book:
% Theory and Applications of Digital Speech Processing,
% L.R. Rabiner, R.W. Schafer
% ISBN:0136034284
%
% Aristotelis Matakias - Summer 2023
% Course: Speech and Audio Processing
% 

% Short-Term processing

winlength=w*Fs/1000;       % moving window length (in samples).
winstep=h*Fs/1000;         % hop size in samples

N = length(x); % signal length

% zero padding for last window

if(mod(N-winlength,winstep)~=0)

    extra_samples = winstep - mod(N-winlength,winstep);
    x = [x ; zeros(extra_samples,1)];
    
end

N = length(x); % new signal length

numOfFrames = (N - winlength)/winstep + 1;

% calculate 

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


            
eavg=mean(Energy(1:trainingFrames));
esig=std(Energy(1:trainingFrames));
zcavg=mean(ZeroCrossRate(1:trainingFrames));
zcsig=std(ZeroCrossRate(1:trainingFrames));

        
IZCT = max(IF,zcavg+3*zcsig);  % Variable Zero Crossing Threshold

IMX = max(Energy);             % Max Log Energy
ITU = IMX-20;                  % High Log Energy Threshold
ITL = max(eavg+3*esig, ITU-10);% Low Log Energy Threshold


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

% Post Processing

classification2 = medfilt1(classification,10);
classification2(classification2 > 1) = 2;



if(visualize==1)

    figure('Name', 'Short-Term processing')
    
    subplot(311)
    stem(x)
    xlabel('Sample')
    ylabel('Amplitude')
    title('Speech Signal')
    grid on
    
    
    backgroundFranes = find(classification2 == 1);
    foregroundFrames = find(classification2 == 2);
    
    
    subplot(312)
    stem(Energy)
    hold on
    xlabel('Frame')
    ylabel('Energy')
    title('Logarimthmic Energy of Each Frame')
    stem(foregroundFrames,Energy(foregroundFrames),'g')
    stem(backgroundFranes,Energy(backgroundFranes),'b')
    legend('Background Frames','Foreground Frames') 
    hold off
    grid on
    
    subplot(313)
    stem(ZeroCrossRate)
    hold on
    xlabel('Frame')
    ylabel('Zerocrossing Rate')
    title('Zerocrossing Rate of Each Frame')
    stem(foregroundFrames,ZeroCrossRate(foregroundFrames),'g')
    stem(backgroundFranes,ZeroCrossRate(backgroundFranes),'b')   
    legend('Background Frames','Foreground Frames') 
    hold off
    grid on

    
    figure('Name', 'Post-processing')
    subplot(211)
    stem(classification)
    title('Initial Classification')
    subplot(212)
    stem(classification2)
    title('Final Classification')
    
end






% word extraction

foregroundFrames = find(classification2 == 2);

% find frame indexes that correspond to words
previous = foregroundFrames(1);
frameStart = foregroundFrames(1);

isolatedWordsIndexes = {};
for i = 2:length(foregroundFrames)

    if foregroundFrames(i)-1 ~= previous
        frameEnd = previous;        
        isolatedWordsIndexes{end + 1} = [frameStart:frameEnd];
        frameStart = foregroundFrames(i);
    end

    if i==length(foregroundFrames)
        frameEnd = foregroundFrames(end);
        isolatedWordsIndexes{end + 1} = [frameStart:frameEnd];
        frameStart = foregroundFrames(i);
    end

    previous = foregroundFrames(i);
        
end


% find samples that correspond to words


if(visualize==1)
    figure('Name', 'Isolated words')
    stem(x)
    xlabel('Sample')
    ylabel('Amplitude')
    title('Speech Signal')
    grid on
    hold on
end


isolatedWords = {};

for k=1:length(isolatedWordsIndexes)
    word = isolatedWordsIndexes{k};
    
    

    firstSample = word(1)*winstep;
    lastSample = word(end)*winstep+winlength-1;
    
    if(lastSample>length(x))
        lastSample = length(x);
    end
    
    % ignore very short words
    if(lastSample-firstSample < 500)
        continue
    end
    
    if(visualize==1)
        xline(firstSample,'Color', [0.4660 0.6740 0.1880]);
        xline(lastSample, 'r');
        stem(firstSample:lastSample, x(firstSample:lastSample),'m')
    end

    

    soundWord = x(firstSample:lastSample);
    isolatedWords{end+1} = soundWord';

end

if(visualize==1)
   legend('Background','Start of word','End of Word','Foreground') 
end





end
