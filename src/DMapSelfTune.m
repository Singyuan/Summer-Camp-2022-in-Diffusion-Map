% Bandwidth is determined by self-tune
% Please refer to L. Zelnik-Manor and P. Perona (2005).
% Please refer to J. Wang (2011) Chapter 14.
function [U, S] = DMapSelfTune(X, NN, Dim)
% X: data is n-by-p means n points in R^p
% NN: the number of nearest points, i.e. kernel function support region
% Dim: the number of eigenvectors, which means reduce R^p to R^Dim
% bandw: force the bandwidth equal to h
% alpha: normalization the density, 1 is normalize, 0 is not. (Default: 0)

[n, p] = size(X);

% Construct bandwidth if it is not given
disp(['Step 1: Find bandwidth of kernel function'])
[idx, dista]= knnsearch(X, X, 'k', NN+1);
idx(:, 1) = []; % no self-loop
dista(:, 1) = [];
disp('(info) No self-loop')
bandw = dista(:, end);

% Let kernel function support on [0, 1.2*bandwidth]
for ii = 1:n
    dista(ii, find(dista(ii,:)>1.5*bandw(ii))) = inf;
end

disp(['(info) The first 20% of "self-tune" bandwidth is chosen: ', num2str(quantile(bandw, 0.2))])
disp(['(info) The median of "self-tune" bandwidth is chosen: ', num2str(median(bandw))])
disp(['(info) The first 80% of "self-tune" bandwidth is chosen: ', num2str(quantile(bandw, 0.8))])

% Construct the affinity matrix as a sparse matrix 
% only index (spi, spj) are assigned value
disp(['Step 2: Construct affinity matrix'])
spi = repmat(1:n, size(dista, 2), 1);
spi = spi(:);
spj = idx';
spj = spj(:);

% affinitymat = exp(-0.5*dista.^2/bandw^2); 
for i = 1:n
    for j = 1:size(dista, 2)
        % 0.5 is for symmetry
        affinitymat(i, j) = exp(-0.5*dista(i, j)^2/(bandw(i)*bandw(idx(i, j))));
    end
end
affinitymat = affinitymat';

W = sparse(spi, spj, affinitymat(:), n, n);
W = W.*W'; % Make sure it is symmetric


% A, tranistion matrix, is similar to symmetric matrix W2
disp(['Step 3: Solve the eigenvectors'])
D = sum(W, 2);
V2 = sparse(1:numel(D), 1:numel(D), sqrt(1./D), n, n);
W2 = V2*W*V2;
W2 = (W2+W2')/2; % artifically added if needed.



% Evaluate the largest Dim+1 eigenvectors (the largest is constant)
[UD, S] = eigs(W2, Dim+1);
U = V2*UD; 
S = diag(S);
[S, lambdaDidx] = sort(S, 'descend');
U = U(:, lambdaDidx);
U = U(:, 2:end); % there is no information in the first eigenvector
S(1) = [];
end

