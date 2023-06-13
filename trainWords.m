

% our dataset:
% coeffsAll = {};
% labels = {};

X = coeffsAll;
Y = labels;

% Step 3: Split the dataset
cv = cvpartition(Y, 'Holdout', 0.2);
X_train = X(training(cv), :);
Y_train = Y(training(cv));
X_test = X(test(cv), :);
Y_test = Y(test(cv));

% Convert labels to numeric indices
[~, Y_train_idx] = ismember(Y_train, unique(Y));
[~, Y_test_idx] = ismember(Y_test, unique(Y));

% Step 4: Train the SVM model
svmModel = fitcecoc(X_train, Y_train_idx);

% Step 5: Evaluate the model
Y_pred = predict(svmModel, X_test);
accuracy = sum(Y_pred == Y_test_idx) / numel(Y_test_idx);
fprintf('Accuracy: %.2f%%\n', accuracy * 100);

% Save the trained model
save('trainedModel', 'svmModel');

% Example usage
featureVector = abs(analyzeWord('dataset/00/0_01_45.wav',0));
% flatten
featureVector = reshape(featureVector.',1,[]);
% zero padding (this will be a parameter)
featureVector = [featureVector zeros(1,8500-length(featureVector))];

prediction = predict(svmModel, featureVector)



