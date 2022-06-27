% The iris data is from MATLAB load('fisheriris')
clc; clear; close all;
addpath('../src', '../data')
load('irismat')
[U, S] = DMapBasic(meas, 80, 2);
% [U, S] = DMapSelfTune(meas, 80, 2);
% [U, S] = DMapRoseland(meas, 50, 4);
% [U, S] = DMapMD(meas, 80, 2);
plot(U(1:50, 1), U(1:50, 2), 'ro')
hold on
plot(U(51:100, 1), U(51:100, 2), 'go')
plot(U(101:150, 1), U(101:150, 2), 'bo')
legend('setosa', 'versicolor', 'virginica', 'FontWeight', 'bold')
title('Classification of fisheriris', 'Fontsize', 16, 'FontWeight', 'bold')