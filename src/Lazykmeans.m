% This code is modified from Kai (2021), Improved Nystrom Kernel Low-rank 
% Approximation (https://www.mathworks.com/matlabcentral/fileexchange/38422
% -improved-nystrom-kernel-low-rank-approximation), MATLAB Central File 
% Exchange.
function [dex, center, m] = Lazykmeans(data, m, MaxIter)
% each row of data is a data point
% data is size of n-by-p, n data points embed in R^p
% choose m landmark
% MaxIter is how many iterative time to find the landmark

if nargin ==2
    MaxIter = 5;
end

n = size(data, 1);
dex = randperm(n);
center = data(dex(1:m), :); % choose m landmark

for i = 1:MaxIter
    nul = zeros(m,1); % avoid no neighbor
%     [xx, idx] = min(sqdist(center', data'));
    idx = knnsearch(center, data, 'k', 1);
    for j = 1:m
        dex = find(idx == j);
        l = length(dex);
        cltr = data(dex,:); % the cluster is close to such center
        
        % update center mean
        if l > 1
            center(j,:) = mean(cltr);
        elseif l == 1
            center(j,:) = cltr;
        else
            nul(j) = 1;
        end
    end
    % make sure all center has nbh
    idex = find(nul == 0);
    m = length(idex);
    center = center(idex,:);
    % dex is nearest data point to center
    % This is for landmark
    dex = knnsearch(data, center, 'k', 1);
    dex = unique(dex);
    m = numel(dex);
end

