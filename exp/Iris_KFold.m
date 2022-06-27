clc; clear; close all;
addpath('../src', '../data')
% load fisheriris
load("irismat.mat")
X = meas;
Y = species;
n = size(X, 1);
Y_hot = zeros(n, 3);
for i = 1:3
    Y_hot(Y==i, i) = 1;
end

% split train and validation set
k_fold = 8;
[train_idices, val_idices] = Split_Set(n, k_fold);

% apply K-fold validation
val_accs = [];
val_f1s = [];
conf_mats = zeros(3); % sum over all validation confusion matrices
for i = 1:k_fold
    train_idx = train_idices{i};
    val_idx = val_idices{i};
    
    % SVM
    template = templateSVM('KernelFunction', 'gaussian', ...
        'PolynomialOrder', [], 'KernelScale', 10, ...
        'BoxConstraint', 1, 'Standardize', true);
    
    % train
    model = fitcecoc(X(train_idx, :), Y(train_idx, :), ...
        'Learners', template, ...
         'Coding', 'onevsone', ...
         'ClassNames', [1; 2; 3]);
    
    [~, train_scores] = predict(model, X(train_idx, :));
    [~, conf_mat] = confusion(Y_hot(train_idx, :)', train_scores');
    train_acc = sum(diag(conf_mat)) / sum(conf_mat(:));

    % evaluation
    [~, val_scores] = predict(model, X(val_idx, :));
    [~, conf_mat] = confusion(Y_hot(val_idx, :)', val_scores');
    [val_f1, val_acc] = CM2MacroF1(conf_mat);
    
    disp_str = sprintf('[ %d / %d ]: Training accuracy = %.3f, Validation accuracy = %.3f', i, k_fold, train_acc, val_acc);
    disp(disp_str)
    
    % store all info
    val_f1s = [val_f1s, val_f1];
    val_accs = [val_accs, val_acc];
    conf_mats = conf_mats+conf_mat;
end
[cell_info, ~, ~] = CM2Info(conf_mats, {'seto', 'vers', 'virg'});
disp('The following is confusion matrix of validation set')
disp(cell_info)

% plot validation accuracy from k-fold validation set
figure
h = boxplot([val_accs', val_f1s'], 'Labels', {'Accuracy','Macro F1 Score'});
text(1.2, median(val_accs),['\leftarrow', num2str(round(median(val_accs), 3))], 'FontSize', 16)
text(1.5, median(val_f1s),[num2str(round(median(val_f1s), 3)), '\rightarrow'], 'FontSize', 16)
ylabel('accuracy')
set(h,'LineWidth', 3)
set(gca,'FontSize',12)
title(['Validation accuracy with (mean, std)=(', num2str(round(mean(val_accs), 3)), ', ' num2str(round(std(val_accs), 3)), ')'], 'Fontsize', 16)