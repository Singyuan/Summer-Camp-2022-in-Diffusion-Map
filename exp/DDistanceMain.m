% Please refer to A. Singer, H.-T. Wu (2011)
% This sphere data is generated from Brian Z Bentz (2021). 
% (https://www.mathworks.com/matlabcentral/fileexchange/57877-mysphere-n), 
% MATLAB Central File Exchange.
clc; clear; close all;
addpath('../src', '../data')
load('UniSphere')
[U, S] = DMapRoseland(X, 100, 4);
for i = 1:size(U, 1)
    DDista(i) = norm(U(i, :)-U(30, :));
end

numofpts = numel(DDista);
jetcustom = jet(3*numofpts); % divide color bar into "many" nodes.
labelbar = linspace(min(DDista), max(DDista), 3*numofpts); % label each nodes a number from min to max
locateidx = knnsearch(labelbar', DDista'); % find our DD belong to which position in color bar
plot3(X(30, 1), X(30, 2), X(30, 3), '*', 'MarkerSize', 10, 'Color', 'k' , 'LineWidth', 3)
hold on
for i = 1:numofpts
   plot3(X(i, 1), X(i, 2), X(i, 3), '.', 'MarkerSize', 7, 'Color', jetcustom(locateidx(i), :));
end
colormap(jetcustom)
cb = colorbar;
caxis([min(DDista), max(DDista)])
ylabel(cb,'Diffusion distance', 'Fontsize', 13)
title('Diffusion distance', 'Fontsize', 16, 'FontWeight', 'bold')