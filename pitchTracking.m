function [fundamentalFreq] = pitchTracking(sig,Fs,visualize)
%PITCHTRACKING Calcuclate the fundamental frequency (pitch) in a speech
%signal
%   This function calculates the fundamental frequency (pitch) in an input
%   speech signal by using the autocorrelation (unbiased and normalized).
%   Also it is assumed that fundamental frequency will be in the interval:
%   [90,600] (Hz).
%
%   Args:
%       sig:        audio speech signal
%       Fs:         sampling frequency of the signal
%       visualize:  0 : do not display autocorrelation diagram
%                   1 : display autocorrelation diagram
%
%   Returns:
%       fundamentalFreq: the fundamental frequency in Hz
%
%

k1 = floor(Fs/600);
k2 = floor(Fs/90);

R = xcorr(sig,'unbiased');
R = R(length(sig) : end);
g = R/R(1); % Normalize

if(visualize==1)
    plot(g)
    hold on
    plot(k1+1:k2+1, g(k1+1:k2+1),'r*')
    hold off
    legend('g','[90,600] Hz')
end

[~,index] = max(g(k1+1:k2+1));

index = index + k1;

fundamentalFreq = Fs/index;

end

