function [Macro_F1, acc, recall, precision] = CM2MacroF1(conf_mat)
num_class = size(conf_mat, 1);
target_total = sum(conf_mat, 2);
nonzero_idx = find(target_total~=0); % avoid there are no element in class
normalizer = zeros(num_class, 1);
normalizer(nonzero_idx) = target_total(nonzero_idx).^(-1);
matHMM = diag(normalizer)*conf_mat;
normalized_confusion_matrix = matHMM;

pred_total = sum(conf_mat, 1);
nonzero_idx = find(pred_total~=0); % avoid there are no element in class
normalizer = zeros(num_class, 1);
normalizer(nonzero_idx) = pred_total(nonzero_idx).^(-1);
normalized_sensitivity_matrix = conf_mat*diag(normalizer);

recall = diag(normalized_confusion_matrix);
precision = diag(normalized_sensitivity_matrix);

F1_score = 2*(recall.*precision)./(recall+precision);
Macro_F1 = mean(F1_score);

acc = sum(diag(conf_mat))/sum(sum(conf_mat));
end