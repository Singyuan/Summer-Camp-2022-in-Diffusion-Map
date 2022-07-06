% Dynamical diffusion map
% Please refer to Y.-T. Lin, J. Malik, H.-T. Wu (2019)
% This ECG data is generated from McSharry PE, Clifford GD, Tarassenko L,
% Smith L. (2003), https://physionet.org/content/ecgsyn/1.0.0/#files
clc; clear; close all;
addpath('../src', '../data')
load('FakeECG')
% sample frequency is 200
time = linspace(0, numel(ecg)/200, numel(ecg));

% plot R peak
figure
hold on
plot(time/60, ecg);
plot(time(rpeaksidx)/60, ecg(rpeaksidx), 'o')

instan_freq = 200./diff(rpeaksidx');
R_peak_time = time(rpeaksidx(2:end)');

% plot instantaneous frequency (reciprocal of RR interval)
figure
plot(R_peak_time/60, instan_freq)


% Apply DM by lag map
L = 7; % L-step lag map
num_eigvec = 3;
bandwidth = 0.06;

% preprocessing by L-step lag map
X_lag = [];
for i = 1:numel(instan_freq)-(L-1)
    X_lag = [X_lag; instan_freq(i:i+L-1)];
end

% apply dm
[U, S] = DMapBasic(X_lag, 800, num_eigvec, bandwidth);

figure
numofpts = size(U, 1);
jetcustom = jet(numofpts);
colormap(jetcustom)

hold on
for i = 1:numofpts
    plot3(U(i, 1), U(i, 2), U(i, 3), '.', 'Color',  jetcustom(i, :))
end
view([45, 30])

colormap(jetcustom)
cb = colorbar;
caxis([0, R_peak_time(end)/60])
ylabel(cb,'time direction (min) \rightarrow', 'Fontsize', 13)
title('Embedding lag map of reciprocal of RRI (freq)', 'Fontsize', 16, 'FontWeight', 'bold')
