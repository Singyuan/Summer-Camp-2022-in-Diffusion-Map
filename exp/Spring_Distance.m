clc; clear; close all;
addpath('../src', '../data')
n = 1000;

diam = 0.8; % cyclinder radius
vert_v = 0.2; % vertical velocity
rotation_num = 3; % number of rotation
bandwidth = 0.5; % kernel bandwidth
diffu_time = 80;

theta = rand(n, 1)*rotation_num*2*pi;
X = zeros(n, 2); % initial
X(:, 1) = diam*cos(theta);
X(:, 2) = diam*sin(theta);
X(:, 3) = vert_v*theta;
% sort by revolution
[theta, idx] = sort(theta);
X = X(idx, :);

% apply diffusion map
[U, S] = DMapBasic(X, 100, 8, bandwidth);

figure
set(gcf,'color','w','units','normalized','position',[0 0.5 0.6 0.4])
subplot(1, 2, 1)
plot3(X(:, 1), X(:, 2),  X(:, 3), '.')

% geodsic distance
geod_dist = sqrt(diam^2+vert_v^2)*theta;
% ambient distance
tmpidx = 1:numel(theta);
idx = tmpidx(theta<2*pi);
amb_dist = vecnorm(X-X(1, :), 2, 2);
subplot(1, 2, 2)
hold on
plot(theta(idx), geod_dist(idx)/geod_dist(idx(end)), 'Linewidth', 1.5)
plot(theta(idx), amb_dist(idx)/amb_dist(idx(end)), 'Linewidth', 1.5)

diff_coord =  U*(diag(S).^50);
diffu_dist = vecnorm(diff_coord-diff_coord(1, :), 2, 2);
plot(theta(idx), diffu_dist(idx)/diffu_dist(idx(end)), 'Linewidth', 1.5)
legend('Geodesic distance', 'Euclidean distance', 'Diffusion distance', 'Location','southeast')
title('Comparison of three normalized distance')
set(gca, 'FontSize', 13) 
hold off

figure
numofpts = numel(diffu_dist);
jetcustom = jet(2*numofpts);
colormap(jet) 
cb = colorbar;
caxis([min(diffu_dist) max(diffu_dist)])
ylabel(cb,'Diffusion Distance', 'Fontsize', 13)

% compute diffusion along time
for t = 0:10:diffu_time
    % compute diffusion distance at time t
    diff_coord =  U*(diag(S).^t);
    diffu_dist = vecnorm(diff_coord-diff_coord(1, :), 2, 2);
    % search the specific distance
    labelbar = linspace(min(diffu_dist), max(diffu_dist), 2*numofpts); % label each nodes a number form min to max
    locateindex = knnsearch(labelbar', diffu_dist); % find our marker belong to which position in color bar
    hold on
    for i = 1:numofpts
        plot3(X(i, 1), X(i, 2), X(i, 3), '.', 'Color',  jetcustom(locateindex(i), :))
    end
    hold off

    title_str = sprintf('Diffusion distance at time %.1f.', t);
    title(title_str)
    view([-45 30])
    drawnow
end

