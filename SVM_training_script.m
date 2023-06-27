
% SVM training script

% NOTICE: make sure you run 'feature_extraction_script' first 

load augmentedDataset\augmentedDatasetLabelsV1.mat

X = cell2mat(vectors');
Y = labels;

% split the dataset to training and testing
cv = cvpartition(labels, 'Holdout', 0.2);
X_train = X(training(cv), :);
Y_train = Y(training(cv));
X_test = X(test(cv), :);
Y_test = Y(test(cv));


% Enable parallel computation.
options = statset('UseParallel',true);
                      
pause
                   
% train SVM Classifier.
SVMClassifier = fitcecoc(X_train, Y_train,'Options',options);
                     
% store only usefull parts for later usage                   
SVMClassifierCompact = SVMClassifier.compact;

save('svmClassifierV1', 'SVMClassifierCompact');



