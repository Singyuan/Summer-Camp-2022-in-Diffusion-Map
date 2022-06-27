function invC = InvTruncCov(data, NN)
n = size(data, 1); % num of data

% Hope there are NN pts in h-nbh about 60% chnace
[~, dst] = knnsearch(data, data, 'k', NN+1);
h = quantile(dst(:, NN+1), 0.6);
if max(dst(:, 2)) > h
    disp('(warning) There are isolated points.')
end
nbhidx = rangesearch(data, data, h);

cback = 0;
for i = 1:n
    if mod(i, 100) == 0
        for cc=1:cback
            fprintf('\b');
        end
        cback = fprintf('%4d', i);
    end
    
    tempidx = nbhidx{i}; % index in h nbh
    % If it is isolated point, choose the nearest 3 pts
    if numel(tempidx) <= 2
        [tempidx, temph] = knnsearch(data, data(i, :),'k', 4);
        tempidx(1) = [];
        tempn = numel(tempidx); % record number in h nbh
        locX = data(tempidx, :)-repmat(data(i, :), tempn, 1); % xj-xi
        loccov = locX'*locX/((tempn-1)*temph(end)^2*tempn/n); % normalization of cov
    else
        tempidx(1) = [];
        tempn = numel(tempidx); % number in h nbh
        locX = data(tempidx, :)-repmat(data(i, :), tempn, 1); % xj-xi
        loccov = locX'*locX/((tempn-1)*h^2*tempn/n); % normalization of cov
    end
    numnbh(i) = tempn;
    % pinv is trunc
    invC{i} = pinv(loccov, 0.0001);
end
fprintf('\n');
disp(['(info) The median number of points in local covariance matrix nbh is ' num2str(median(numnbh)), '.'])
disp(['(info) The first 10% number of points in local covariance matrix nbh is ' num2str(quantile(numnbh, 0.10)), '.'])