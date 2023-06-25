function [outputArg1,outputArg2] = isolateWords(x,Fs,w,h)
%ISOLATEWORDS Summary of this function goes here
%   Detailed explanation goes here

%w                      % moving window length in ms
winlength=w*Fs/1000;       % moving window length (in samples).
%h                     % hop size in ms
winstep=h*Fs/1000;         % hop size in samples

N = length(x); % signal length



if(mod(N-w,winstep)~=0)

    extra_samples = winstep - mod(N-w,winstep);
    x = [x ; zeros(extra_samples,1)];
    
end

N = length(x); % new signal length

numOfFrames = (N - winlength)/winstep + 1;

Energy = zeros(1,numOfFrames,'double');
ZeroCrossRate = zeros(1,numOfFrames,'uint8');


for m=1:numOfFrames

    %frame = x((m-1)*winstep:)

end

end
