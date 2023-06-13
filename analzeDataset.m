
% analyzing the current dataset

% WARNING: in UNIX OS the path is specified differently '/'


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

        featureVector = abs(analyzeWord(audioname,0));

        % flatten
        featureVector = reshape(featureVector.',1,[]);

        % zero padding (this will be a parameter)
        featureVector = [featureVector zeros(1,8500-length(featureVector))];

        coeffsAll{end+1} = featureVector;
        labels{end+1} = i;
    end
end

% check lengths...
allLengths = cellfun(@length, coeffsAll);
maxLength = max(allLengths)

coeffsAll = coeffsAll';

coeffsAll = cell2mat(coeffsAll);
labels = cell2mat(labels);
labels= labels';

