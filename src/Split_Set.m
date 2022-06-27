function [train_idx, val_idx] = Split_Set(n_data, input_number)
% if input_num < 1, use ratio to split training and val set
% Note that here, input_num is training ratio
if input_number < 1
    train_ratio = input_number;
    val_num = floor((1-train_ratio)*n_data);
    val_idx = randsample(n_data, val_num);
    all_idx = 1:n_data;
    train_idx = all_idx(~ismember(all_idx, val_idx));
    
% if input_num < 1, split by K-fold
% Note that here, input_number is K
elseif input_number > 1
    K = input_number;
    rand_idx = randperm(n_data);
    remain = mod(n_data, K);
    remain_idx = rand_idx(1:remain);
    rand_idx(1:remain) = [];
    rand_idx = reshape(rand_idx, K, []);
    val_idx = mat2cell(rand_idx, ones(1, K));
    for i = 1:numel(remain_idx)
        val_idx{i} = [val_idx{i}, remain_idx(i)];
    end
    
    all_idx = 1:n_data;
    train_idx = cell(K, 1);
    for i = 1:K
        train_idx{i} = all_idx(~ismember(all_idx, val_idx{i}));
    end
elseif input_number == 1
    train_idx = 1:n_data;
    val_idx = 0;
end
end