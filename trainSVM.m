
load augmentedDatasetLabels.mat

X = cell2mat(vectors');
Y = labels;

% Step 3: Split the dataset
cv = cvpartition(labels, 'Holdout', 0.2);
X_train = X(training(cv), :);
Y_train = Y(training(cv));
X_test = X(test(cv), :);
Y_test = Y(test(cv));



% Generate a template SVM classifier.
SVMTemplate = templateSVM('KernelFunction','gaussian','standardize',true,...
                          'SaveSupportVectors',true,'Verbose',1);

% Enable parallel computation.
options = statset('UseParallel',true);
                      
pause

% -------------------------------------------------------------------------                      
% Train SVM Classifier.
% -------------------------------------------------------------------------
SVMClassifier = fitcecoc(X_train, Y_train,'Options',options);
                     
                     
                     