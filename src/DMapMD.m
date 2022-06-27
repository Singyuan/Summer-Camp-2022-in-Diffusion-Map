% Diffusion map via Mahalanobis distance instead of Euclidean distance
% Please refer to J. Malik, C. Shen, H.-T. Wu, N. Wu (2019)
function [U, S] = DMapMD(X, NN, Dim)
% X: data is n-by-p means n points in R^p
% NN: the number of nearest points, i.e. kernel function support region
% Dim: the number of eigenvectors, which means reduce R^p to R^Dim

[n, p] = size(X);

disp(['Step 1: Construct local truncated inverse covariance matrix'])
invC = InvTruncCov(X, NN);


% The largest NN "Mahal distance" might not be largest NN Euclidean
% distance, so we find more points 1.5*NN
disp(['Step 2: Compute the Mahal distance between neighbor points'])
idx = knnsearch(X, X, 'k', floor(1.5*NN));

idx = idx(:, 2:end); % no self-loop
for i = 1:n
    for j = 1:size(idx, 2)
        v = X(i, :)-X(idx(i, j), :); 
        distaMD(i, j) = sqrt(0.5*v*(invC{i}+invC{idx(i, j)})*v');
    end
end
% recovery to origin NN points
trunc = quantile(distaMD, 0.66, 2);
distaMD(distaMD > trunc) = inf;


% Find bandwidth
disp(['Step 3: Find bandwidth of kernel function'])
% [] is because max(A, B) compare A and B
% note that there are infinity entries
for i = 1:n
    h(i) = max(distaMD(i, ~isinf(distaMD(i, :))));
end
bandw = quantile(h, 0.5);

% Let kernel function support on [0, 1.5*bandwidth]
for ii = 1:n
    distaMD(ii, find(distaMD(ii, :)>1.5*bandw)) = inf;
end


% Fix the isolated problem by nearest 3 points
disp(['Step 4: Fix isolated points problem.'])
numnbh = sum(~isinf(distaMD), 2);
isoidx = find(numnbh<=1);
if ~isempty(isoidx)
    disp('(warning) There are isolated points.')
    for i = 1:numel(isoidx)
        [tempidx, tempdist] = knnsearch(X, X(isoidx, :), 'k', 4);
        idx(isoidx, 1:3) =  tempidx(2:end); % no self-loop
        distaMD(isoidx, 1:3) =  tempdist(2:end); % no self-loop
    end
else
    disp('(info) There are no isolated point.')
end

disp(['(info) The median number of points in bandwidth neighborhood is ', num2str(median(numnbh)), '.'])
disp(['(info) The first 10% number of points in bandwidth neighborhood is ', num2str(quantile(numnbh, 0.1)), '.'])


% Construct the affinity matrix as a sparse matrix 
% only index (spi, spj) are assigned value
disp(['Step 5: Construct affinity matrix'])
spi = repmat(1:n, size(distaMD, 2), 1);
spi = spi(:);
spj = idx';
spj = spj(:);

affinitymat = exp(-0.5*distaMD.^2/bandw^2); % 0.5 is for symmetry
affinitymat = affinitymat';

W = sparse(spi, spj, affinitymat(:), n, n);
W = W.*W'; % Make sure it is symmetric


% A, tranistion matrix, is similar to symmetric matrix W2
disp(['Step 6: Solve the eigenvector'])
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

