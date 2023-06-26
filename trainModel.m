clc
clear
close all


load augmentedDataset\augmentedDataset.mat


sig = zeros(1,8000);
vectors = {};

for k=1:length(signals)
    
   sig = [signals{k} zeros(1,8000- length(signals{k}))];
   
   coeffs = spectrogram(sig,100,80,100,8000,'yaxis');
   coeffs = abs(coeffs);
   coeffs = reshape(coeffs.',1,[]);
   size(coeffs);
   
   vectors{end+1} = coeffs;
end

