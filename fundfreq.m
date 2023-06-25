% Fundamental Frequency Calculator script

% Summary
% 
% 
%
%
%
%
% Aristotelis Matakias - Summer 2023


% assuming 'Fs' and words in cell array 'isolatedWords'
%
% fundamental frequency will be in the interval:
% [90,600] (Hz)

k1 = floor(Fs/600);
k2 = floor(Fs/90);

sig = isolatedWords{3};

figure('Name', 'Word (filtered and subsampled)')
plot(sig)

Ru = xcorr(sig,'unbiased');
Ru = Ru(length(sig) : end);
g = Ru/Ru(1); % Normalize

figure('Name', 'R')
plot(g)
hold on
plot(k1+1:k2+1, g(k1+1:k2+1),'r*')

[~,index] = max(g(k1+1:k2+1));

index = index-1 + k1;

Fs/index

