function [xnew] = srcLowPassFilter(x, FsOrig, Fs)
%RESAMPLENONINTEGER Performs Sample Rate Conversion for 1D input signal x
%   Detailed explanation goes here
%
%
%   Theory based on:  Discrete-time signal processing (2nd edition), Oppenheim, Schafer
%
%   Code based on:  https://www.mathworks.com/help/signal/ref/resample.html
%                   https://www.mathworks.com/help/signal/ref/upfirdn.html

% calcumate the fraction
[p,q] = rat(Fs / FsOrig)

maxpq = max(p,q);

% create the FIR filter
fc = 1/maxpq;
n = 10;
order = 2*n*maxpq;
beta = 5;

b = fir1(order,fc,kaiser(order+1,beta));
b = p*b/sum(b);


xnew = upsample(x, p); % upsample (by inserting zeros)

xnew = filter(b, 1, xnew); % apply filter to the upsampled signal

xnew = downsample(xnew, q); % downsample the filtered signal by q


delay = floor(((filtord(b)-1)/2-(p-1))/p);


xnew = xnew(delay+1:end);




end

