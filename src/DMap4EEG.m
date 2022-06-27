function [U, S] = DMap4EEG(X, dim, bandw)
dist_matrix = squareform(pdist(X, 'euclidean'));
if nargin == 2
    bandw = quantile(dist_matrix(:), 0.4);
end
disp(['The kernel bandwidth is ', num2str(bandw), '.'])

dist_matrix(dist_matrix>2.0*bandw) = inf;
W = exp(-dist_matrix/bandw);

% no self-loop
for i=1:size(W, 1)
    W(i, i)=0;
end
D = sparse(diag(1./sum(W, 2)));
[U, S] = eigs(D*W, dim+1);
U = real(U);
S = diag(real(S));
[S, lambdaDidx] = sort(S, 'descend');
U = U(:, lambdaDidx);
U = U(:, 2:end); % there is no information in the first eigenvector
S = S(2:end);
end