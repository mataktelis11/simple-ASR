
% how to use function 'numbersASR'

% load a trained SVM
load trainedModelsCompact\svmClassifierV0.mat;

% load a speech audio file
[speech,FsOrig]=audioread('samples/3rec.wav');

[Y,pitch] = numbersASR(speech,FsOrig,SVMClassifierCompact)

% or record yourself! (copy commands to cmd)
%
% r = audiorecorder(44100,16,1);
% record(r) % speak
% stop(r)
% speech = getaudiodata(r);
% soundsc(speech, 44100)
% load trainedModelsCompact\svmClassifierV0.mat;
% [Y,pitch] = numbersASR(speech,44100,SVMClassifierCompact)