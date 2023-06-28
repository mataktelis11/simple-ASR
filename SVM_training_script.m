
%
% Step 3/4
%

% SVM training script

% NOTICE: make sure you run 'feature_extraction_script' first 
%         in order to have the cell array with the feature vectors

% SUMMARY
% 
% This script reads the saved feature Vectors from an existing cell
% array and separates them into a training set and a testing set, in order
% to train an SVM.
%
% Before the training starts, the script shows a figure containing
% 16 random spectrograms from the dataset.
%
% Important: before the training starts, the command 'pause' is called.
%            Press any key to start the training and keep in mind it will
%            take some time.

X = cell2mat(featureVectors');
Y = labels;

% split the dataset to training and testing
cv = cvpartition(labels, 'Holdout', 0.2);
X_train = X(training(cv), :);
Y_train = Y(training(cv));
X_test = X(test(cv), :);
Y_test = Y(test(cv));


% Enable parallel computation.
options = statset('UseParallel',true);

% pause before starting the training
pause
                   
% train SVM Classifier.
SVMClassifier = fitcecoc(X_train, Y_train,'Options',options);
                     
% store only usefull parts for later usage                   
SVMClassifierCompact = SVMClassifier.compact;

save('trainedModelsCompact\svmClassifierV1', 'SVMClassifierCompact');



