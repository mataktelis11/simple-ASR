% Convert labels to numeric indices
[~, Y_train_idx] = ismember(Y_train, unique(Y));
[~, Y_test_idx] = ismember(Y_test, unique(Y));


% Save the trained model
save('trainedModel', 'SVMClassifier');



prediction = predict(SVMClassifier, vectors{end})