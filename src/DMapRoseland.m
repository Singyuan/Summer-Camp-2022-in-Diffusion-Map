% Reduced diffusion map via Roseland method
% Please refer to C. Shen, H.-T. Wu (2019)
function [U, S] = DMapRoseland(X, NN, Dim, m)
% X: data is n-by-p means n points in R^p
% NN: for self tune bandwidth
% Dim: the number of eigenvectors, which means reduce R^p to R^Dim
% m: number of landmark points (Default: sqrt(n))

[n, p] = size(X);

% Use k-means to find landmark
disp(['Step 1: Use k-means to find landmark.'])
if nargin == 3
    m = floor(sqrt(n));
    disp(['(info) The number of landmark is chosen: ', num2str(m), '.'])
end
refdex = Lazykmeans(X, m);
ref = X(refdex, :);
m = size(ref, 1); % center points might be the same, update m

% Form affinity matrix w.r.t. the ref set
affinity_ext = pdist2(X, ref);

% Construct bandwidth if it is not given
disp(['Step 2: Construct bandwidth of kernel function.'])
[~, dista]= knnsearch(X, X, 'k', NN+1);
dista(:, 1) = [];
bandw = dista(:, end);

% Remove the reference data far from such row data
isocount = 0;
for ii = 1:n
    % check each point have at least 1 reference data close to it.
    if sum(affinity_ext(ii, :)<3*bandw(ii)) <= 2
        trunc = quantile(affinity_ext(ii), 0.3);
        affinity_ext(affinity_ext >= trunc) = inf;
        isocount = isocount+1;
    else
        affinity_ext(ii, find(affinity_ext(ii, :)>3*bandw(ii))) = inf;
    end
end
q = 100*sum(sum(isinf(affinity_ext)))/(m*n);
numref = sum(~isinf(affinity_ext), 2);
% Since it's easy to be far from the reference points, so we hope the
% chance of such event happening is low.
if (isocount/n)>(sqrt(n)/n)
    disp('(warning) There are "too many" points which are not close to reference data.')
end
disp(['(info) Now, there are ', num2str(q), '% distance being truncated.'])
disp(['(info) Now, the median number of reference points colse to one point is ', num2str(median(numref)), '.'])
disp(['(info) Now, the first 10% number of points in bandwidth neighborhood is ', num2str(quantile(numref, 0.1)), '.'])


% Construct the affinity matrix (n all data)-by-(m reference data)
% Make it as sparse matrix in order to solve the largest ev
disp(['Step 3: Construct affinity matrix'])
for i = 1:n
    for j = 1:m
        W_ref(i, j) = exp(-affinity_ext(i, j)^2/(bandw(i)*bandw(refdex(j))));
    end
end
W_ref = sparse(W_ref);

% Construct sparse D = D^{-.5}
% use W = Wref*Wref'
disp(['Step 4: Compute the degree matrix. Note that W = Wref*Wref^T.'])
D = W_ref * sum(W_ref, 1)';

V2 = D.^(-0.5);
V2 = sparse(1:n, 1:n, V2, n, n);
W_ref = V2 * W_ref;


% SVD
disp(['Step 5: Solve the eigenvectors by SVD.'])
[UD, S] = svds(W_ref, Dim+1);
U = V2*UD;
S = diag(S);
S = S.^2; % sigular value of A = eigenvaue^2 of A*A'
U(:, 1) = [];
S(1) = [];
end

