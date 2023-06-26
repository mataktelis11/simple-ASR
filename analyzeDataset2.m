



clc
clear
close all


coeffsAll = {};
labels = {};

folders = dir('dataset/*');
folders = {folders.name};
folders = folders(3:end); % for UNIX remove '.' and '..'


for i=1:length(folders)
   
    audifiles = dir(strcat('dataset/',folders{i},'/*'));
    audifiles = {audifiles.name};
    audifiles = audifiles(3:end); % for UNIX remove '.' and '..'
    
    for file=1:length(audifiles)
        % read image
        audioname = strcat('dataset/',folders{i},'/',audifiles{file});

        audioname
    end
end