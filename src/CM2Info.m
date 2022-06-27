function [cell_info, Macro_F1, precision, recall] = CM2Info(conf_mat, label_name)
% label_name is a 1-by-n cell type which contain label.
num_class = size(conf_mat, 1);
if nargin == 1
    target_name = {1, num_class};
    pred_name = {1, num_class};
    for i = 1:num_class
        target_name{i} = ['Target-', num2str(i)];
        pred_name{i} = ['Predict-', num2str(i)];
    end
elseif nargin == 2
    for i = 1:num_class
        target_name{i} = ['Target-', label_name{i}];
        pred_name{i} = ['Predict-', label_name{i}];
    end
end
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

ACC = sum(diag(conf_mat))/sum(sum(conf_mat));


output = cell(num_class+3, num_class+4);
% info_cell(1, 2:end) = {'Predict-W', 'Predict-REM', 'Predict-N1', 'Predict-N2', 'Predict-N3', 'PR', 'RE', 'F1'};
% info_cell(2:6, 1) = {'Target-W', 'Target-REM', 'Target-N1', 'Target-N2', 'Target-N3'};
output(1, 2:num_class+4) = [pred_name, {'PR', 'RE', 'F1'}];
output(2:num_class+1, 1) = target_name;
output(2:num_class+1, 2:num_class+1) = num2cell(conf_mat);
output(2:num_class+1, num_class+2) = num2cell(precision);
output(2:num_class+1, num_class+3) = num2cell(recall);
output(2:num_class+1, num_class+4) = num2cell(F1_score);
output(num_class+3:num_class+4, 1) = {['Accuracy: ' num2str(round(ACC, 4))], ['Macro F1: ' num2str(round(Macro_F1, 4))]};

target_sum = sum(cell2mat(output(2:num_class+1, 2:num_class+1)), 2);
target_sum = kron(target_sum, ones(1, num_class));
output2 = cell2mat(output(2:num_class+1, 2:num_class+1))./target_sum;
percell = cell(num_class, num_class);
for i = 1:numel(output2)
    percell{i} = strcat('(', num2str(round(output2(i)*100, 0)),'%)');
end

cell_info = output;
for i = 2:num_class+1
    for j = 2:num_class+1
        cell_info{i, j} = [num2str(output{i, j}), ' ', percell{i-1, j-1}];
    end
end

for i = 2:num_class+1
    tmp = strcat('(', num2str(round(target_total(i-1)/sum(target_total)*100, 0)),'%)');
    cell_info{i, 1} = [output{i, 1}, ' ', tmp()];
end
end