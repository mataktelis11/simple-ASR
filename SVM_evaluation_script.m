
%
% Step 4/4
%

% SVM evaluation script

% NOTICE: make sure you run 'SVM_training_script' first 

% SUMMARY
%
% This script shows some metrics regarding the accuracy of 
% 'SVMClassifier'. Make sure it is loaded.
%

% show the confusion matrix of the training set
figure;
Y_predicted =  predict(SVMClassifier, X_train);
cm1 = confusionchart(Y_train,Y_predicted);
cm1.RowSummary = 'row-normalized';
cm1.ColumnSummary = 'column-normalized';
cm1.Title = 'Training Confusion Matrix';


% show the confusion matrix of the testing set
figure;
Y_predicted =  predict(SVMClassifier, X_test);
cm2 = confusionchart(Y_test,Y_predicted);
cm2.RowSummary = 'row-normalized';
cm2.ColumnSummary = 'column-normalized';
cm2.Title = 'Testing Confusion Matrix';


error = resubLoss(SVMClassifier)

fprintf('Resubstitution classification error = %f\n', error);

pause

% cross-validate SVMClassifier using 10-fold cross-validation
CVSVM = crossval(SVMClassifier);
% estimate the generalized classification error
genError = kfoldLoss(CVSVM)

fprintf('Generalized classification error = %f\n', genError);



