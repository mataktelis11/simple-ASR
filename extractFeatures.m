function [featureVector] = extractFeatures(sig,featureLength,visualize)
%EXTRACTFEATURES Extract a feature Vector from an audio signal.
%   This function creates a feature vector from an input signal from the
%   spectrogram. The coefficients of the spectrogram are turned to a 1D
%   matrix (flattened) and zero padding is done to reach the given length
%   (featureLength)
%
%   Args:
%       sig:            audio signal
%       featureLength:  length of the feature vector
%       visualize:       0 : do not display spectrogram
%                        1 : display spectrogram 
%
%   Returns:
%       featureVector: the feature vector corresponding to the input signal
%
%

% zeropadding to reach featureLength
sig = [sig zeros(1,featureLength - length(sig))];

% calculate the spectrogram
featureVector = spectrogram(sig,100,80,100,8000,'yaxis');
% take the absolute values of the Fourier Coefficients
featureVector = abs(featureVector);
% flatten
featureVector = reshape(featureVector.',1,[]);

size(featureVector);

if(visualize==1)
    spectrogram(sig,100,80,100,8000,'yaxis');
end

end

