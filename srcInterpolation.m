function [xnew] = srcInterpolation(x, FsOrig, Fs)
%SRCINTERPOLATION Summary of this function goes here
%   Detailed explanation goes here

resampleRatio = Fs / FsOrig;

tOrig = (0:length(x)-1) / FsOrig;

tNew = (0:(length(x)*resampleRatio) - 1) / Fs;

xnew = interp1(tOrig, x, tNew, 'cubic');



end

