clc; clear; close all;
addpath('../src', '../data')
rng(1)
theta = rand(1000, 1)*2*pi;
theta = sort(theta);
X = [cos(theta) sin(theta)];
X = [X; 1, 1; -1, -1]; % test for isolated points
% [U, S] = DMapBasic(X, 20, 4);
[U, S] = DMapBasic(X, 100, 4);
% [U, S] = DMapSelfTune(X, 20, 4);
% [U, S] = DMapRoseland(X, 100, 4);
% [U, S] = DMapMD(X, 20, 4);

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
ylabel(cb,'flow direction (\theta) \rightarrow', 'Fontsize', 13)
title('Eigenvectors of Laplacian S^1', 'Fontsize', 16, 'FontWeight', 'bold')