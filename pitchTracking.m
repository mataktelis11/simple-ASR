function [fundamentalFreq] = pitchTracking(sig,Fs,visualize,title)
%PITCHTRACKING Summary of this function goes here
%   Detailed explanation goes here

% fundamental frequency will be in the interval:
% [90,600] (Hz)

k1 = floor(Fs/600);
k2 = floor(Fs/90);

Ru = xcorr(sig,'unbiased');
Ru = Ru(length(sig) : end);
g = Ru/Ru(1); % Normalize

if(visualize==1)
    figure('Name', title)
    plot(g)
    hold on
    plot(k1+1:k2+1, g(k1+1:k2+1),'r*')
    hold off
end

[~,index] = max(g(k1+1:k2+1));

index = index-1 + k1;

fundamentalFreq = Fs/index;

end

