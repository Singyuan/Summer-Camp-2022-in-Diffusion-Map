clc; clear; close all;
addpath('../src', '../data')
load("EEG_spectrum.mat")
n = size(X, 1);
Y_hot = zeros(n, 3);
for i = 1:5
    Y_hot(Y==i, i) = 1;
end

% Dimension reduction by DM
[U, S] = DMap4EEG(X, 30);

% split train and validation set
train_ratio = 0.8;
[train_idx, val_idx] = Split_Set(n, train_ratio);

% SVM
template = templateSVM('KernelFunction', 'gaussian', ...
    'PolynomialOrder', [], 'KernelScale', 10, ...
    'BoxConstraint', 1, 'Standardize', true);

model = fitcecoc(U(val_idx, :), Y(val_idx, :), ...
    'Learners', template, ...
     'Coding', 'onevsone', ...
     'ClassNames', [1; 2; 3; 4; 5]);
 
[~, train_scores] = predict(model, U(train_idx, :));
[~, conf_mat] = confusion(Y_hot(train_idx, :)', train_scores');

acc = sum(diag(conf_mat)) / sum(conf_mat(:));
disp(['Training accuracy = ' num2str(acc)])

[~, val_scores] = predict(model, U(val_idx, :));
[~, conf_mat] = confusion(Y_hot(val_idx, :)', val_scores');

[cell_info, ~, ~, ~] = CM2Info(conf_mat, {'Aw', 'REM', 'N1', 'N2', 'N3'});
disp('The following is confusion matrix of validation set')
disp(cell_info)