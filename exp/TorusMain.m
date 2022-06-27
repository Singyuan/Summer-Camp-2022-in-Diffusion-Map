% Recover torus into S1 or disc (band)?
clc; clear; close all;
addpath('../src', '../data')
n = 2000;
% If increases kernel bandwidth and decreases the tube radius?
% If decreases kernel bandwidth and increases the tube radius?
% Note that make sure it still a torus!!
RevoR = 4; % revolution radius
TubeR = 1.5; % tube radius
Bandwidth = 1.0; % kernel bandwidth

theta = (rand(n, 1)-0.5)*2*pi;
phi = (rand(n, 1)-0.5)*2*pi;
X(:, 1) = (RevoR+TubeR*cos(phi)).*cos(theta);
X(:, 2) = (RevoR+TubeR*cos(phi)).*sin(theta);
X(:, 3) = TubeR*sin(phi);
% sort by revolution
[~, idx] = sort(theta);
X = X(idx, :);

% Here the bandwidth is given
[U, S] = DMapBasic(X, 100, 4, Bandwidth);

figure
numofpts = size(U, 1);
jetcustom = jet(numofpts); % partition the color bar from blue to red
for i = 1:numofpts
    plot3(U(i, 1), U(i, 2), U(i, 3), '.', 'Color',  jetcustom(i, :))
    hold on
end

colormap(jetcustom)
cb = colorbar;
caxis([0, 2*pi])
ylabel(cb,'Revolution direction (\theta) \rightarrow', 'Fontsize', 13)
title('Embedding Torus where (Tube radius, bandwidth)=(0.5, 1.0)', 'Fontsize', 16, 'FontWeight', 'bold')