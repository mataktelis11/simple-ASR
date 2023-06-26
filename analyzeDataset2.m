



clc
clear
close all


coeffsAll = {};
labels = {};

folders = dir('audioData2/*');
folders = {folders.name};
folders = folders(3:end); % for UNIX remove '.' and '..'

lengths = [];

for i=1:length(folders)
   
    audifiles = dir(strcat('audioData2/',folders{i},'/*'));
    audifiles = {audifiles.name};
    audifiles = audifiles(3:end); % for UNIX remove '.' and '..'
    
    for file=1:length(audifiles)
        % read image
        audioname = strcat('audioData2/',folders{i},'/',audifiles{file});

        featureVector = abs(analyzeWord(audioname,0));
        
    end
end





