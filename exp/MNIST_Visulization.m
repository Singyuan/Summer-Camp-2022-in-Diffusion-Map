% This MNIST dataset is from https://github.com/sunsided/mnist-matlab
clc; clear; close all;
addpath('../src', '../data')
% [images, labels, ~] = digitTrain4DArrayData;
load ('mnist.mat')
land_mark = 200;

cnt = 1;
figure
set(gcf,'color','w','units','normalized','position',[0 0.5 0.6 0.4])
for i = 1:size(images, 3)
    if cnt-1 ~= labels(i)
        continue
    end
    subplot(2, 5, cnt)
    imagesc(images(:, :, i));
    colormap('gray');
    axis image off
    cnt = cnt+1;
    if cnt > 10
        break
    end
end

% flatten
images = reshape(images, [], 5000)';

% dimension reduction via DM
[U, S] = DMapRoseland(images, 1000, 4, land_mark);
% [U, S] = DMapBasic(images, 1000, 4);

figure
hold on
jetcustom = jet(10);
colormap(jetcustom);
cb = colorbar;
cb.Ticks = (0:0.1:0.9)+0.05;
cb.TickLabels = num2cell(0:1:9) ; 

for i = 1:10
    idx = (labels==i);
    plot3(U(idx, 1), U(idx, 2), U(idx, 3), '.', 'Color', jetcustom(i, :));
end
view([45, 30])