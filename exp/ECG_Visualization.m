clc; clear; close all;
addpath('../src', '../data')

load('ECGdataset')
figure
set(gcf,'color','w','units','normalized','position',[0 0.5 0.6 0.4])
for i = 1:3
    subplot(2, 3, i)
    plot((1:187)/200, X(i, :), 'LineWidth', 1.2)
    title('normal', 'Fontsize', 18, 'FontWeight', 'bold')
    xlabel('time (sec)')
    set(gca, 'FontSize', 13) 
end

for i = 4:6
    subplot(2, 3, i)
    plot((1:187)/200, X(end-i, :), 'LineWidth', 1.2)
    title('abnormal', 'Fontsize', 18, 'FontWeight', 'bold')
    xlabel('time (sec)')
    set(gca, 'FontSize', 13) 
end

    
[U, S] = DMapRoseland(X, 300, 20);

figure
hold on
plot3(U(Y==1, 1), U(Y==1, 2), U(Y==1, 3), 'r.')
plot3(U(Y==0, 1), U(Y==0, 2), U(Y==0, 3), 'b.')
lgd = legend({'normal', 'abnormal'}, 'FontSize', 14);
title('Classification of ECG via Dmap', 'Fontsize', 18, 'FontWeight', 'bold')
set(lgd,'Location', 'northeast')