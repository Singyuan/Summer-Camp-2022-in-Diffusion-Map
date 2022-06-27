function [U, S] = DMapBasic(X, NN, Dim, bandw, alpha)
% X: data is n-by-p means n points in R^p
% NN: the number of nearest points, i.e. kernel function support region
% Dim: the number of eigenvectors, which means reduce R^p to R^Dim
% bandw: force the bandwidth equal to h
% alpha: normalization the density, 1 is normalize, 0 is not. (Default: 0)

[n, p] = size(X);

% Construct bandwidth if it is not given
disp(['Step 1: Construct bandwidth of kernel function.'])
if nargin == 3
    % search for the nearnest neighbors determine bandwidth
    [idx, dista]= knnsearch(X, X, 'k', NN+1);
    idx(:, 1) = []; % no self-loop
    dista(:, 1) = [];
    disp('(info) No self-loop')
    bandw = quantile(dista(:, end), 0.5);
else
    [idx, dista]= knnsearch(X, X, 'k', NN+1);
    idx(:, 1) = []; % no self-loop
    dista(:, 1) = [];
    disp('(info) No self-loop')
    disp('(info) The bandwidth is given.')
end

% Let kernel function support on [0, 1.5*bandwidth]
for ii = 1:n
    dista(ii, find(dista(ii, :)>1.5*bandw)) = inf;
end

% Fix the isolated problem by nearest 3 points
numnbh = sum(~isinf(dista), 2);
isoidx = find(numnbh == 0);
if ~isempty(isoidx)
    disp('(warning) There are isolated points.')
    for i = 1:numel(isoidx)
        [tempidx, tempdist] = knnsearch(X, X(isoidx(i), :), 'k', 4);
        idx(isoidx(i), 1:3) =  tempidx(2:4); % no self-loop
        dista(isoidx(i), 1:3) =  tempdist(2:4);
    end
else
    disp('(info) There are no isolated point.')
end

disp(['(info) The median number of points in bandwidth neighborhood is ', num2str(median(numnbh)), '.'])
disp(['(info) The first 10% number of points in bandwidth neighborhood is ', num2str(quantile(numnbh, 0.1)), '.'])

% Construct the affinity matrix as a sparse matrix 
% only index (spi, spj) are assigned value
disp(['Step 2: Construct affinity matrix'])
spi = repmat(1:n, size(dista, 2), 1);
spi = spi(:);
spj = idx';
spj = spj(:);

affinitymat = exp(-0.5*dista.^2/bandw^2); % 0.5 is for symmetry
affinitymat = affinitymat';

W = sparse(spi, spj, affinitymat(:), n, n);
W = W.*W'; % Make sure it is symmetric

% normalization
if nargin == 5
    disp(['Step 3: Normalize the probability density function'])
    D = sum(W, 2);
    V1 = sparse(1:numel(D), 1:numel(D), 1./D.^alpha, n, n);
    W = V1*W*V1;
else
    disp(['Step 3: Ignore the probability density function'])
end

% A, tranistion matrix, is similar to symmetric matrix W2
disp(['Step 4: Solve the eigenvector'])
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

