% Dynamical diffusion map
% Please refer to Y.-T. Lin, J. Malik, H.-T. Wu (2019)
% This ECG data is generated from McSharry PE, Clifford GD, Tarassenko L,
% Smith L. (2003), https://physionet.org/content/ecgsyn/1.0.0/#files
clc; clear; close all;
addpath('../src', '../data')
load('FakeECG')
% sample frequency is 200
t = linspace(0, numel(ecg)/200, numel(ecg));
[U, S] = DMapRoseland(ws, 300, 4);
% [U, S] = DMapMD(ws, 300, 4);
figure
plot(t, ecg);
hold on
% standard normalization the eigenvector
ecgflow = U(:, 1)/(200*std(U(:, 1)))+1.18;
plot(t(rpeaksidx), ecgflow, 'LineWidth', 1.5)
axis tight
legend('ECG', 'Flow', 'FontWeight', 'bold')
title('Dynamical Diffusion Map', 'Fontsize', 16, 'FontWeight', 'bold')