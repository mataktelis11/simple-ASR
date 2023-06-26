%

clc
clear
close all


fs = 1000;
t = 0:1/fs:2-1/fs;
y = chirp(t,100,1,200,'quadratic');


spectrogram(y,100,80,100,fs,'yaxis')

coeffs = spectrogram(y,100,80,100,fs,'yaxis');

c2 = analyzeWord('samples/ZA.waV',1);