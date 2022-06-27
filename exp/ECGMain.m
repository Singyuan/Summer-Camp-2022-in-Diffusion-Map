% This ECG data is generated from McSharry PE, Clifford GD, Tarassenko L,
% Smith L. (2003), (https://physionet.org/content/ecgsyn/1.0.0/#files)
clc; clear; close all;
addpath('../src', '../data')
load('FakeECG')
t = linspace(0, numel(ecg)/200, numel(ecg));
[U, S] = DMapBasic(ws, 200, 4);
% [U, S] = DMapSelfTune(ws, 200, 4);
% [U, S] = DMapRoseland(ws, 300, 4);
% [U, S] = DMapMD(ws, 300, 4);

figure
numofpts = size(U, 1);
jetcustom = jet(numofpts); % partition the color bar from blue to red
for i = 1:numofpts
    plot3(U(i, 1), U(i, 2), U(i, 3), '.', 'Color',  jetcustom(i, :))
    hold on
end

colormap(jetcustom)
cb = colorbar;
caxis([0, t(end)/60])
ylabel(cb,'time direction (min) \rightarrow', 'Fontsize', 13)
title('ECG pulse flow', 'Fontsize', 16, 'FontWeight', 'bold')