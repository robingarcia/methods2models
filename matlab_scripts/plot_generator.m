%% Plot generator for datasets
filename = uigetfile('~/methods2models/datasets');
datafile = importdata(filename);
load('toetcher_statenames.mat');
n = size(datafile,2);

c = zeros(4, 31);
c(1,[3 4 9 10 30]) = 1;    % CycBT
c(2,[2 15 29]) = 1;        % CycAT
c(3,[5 16 31]) = 1;        % CycET
c(4,12) = 1;               % Cdc20A

figure(2)
plot(xSol.x, c*xSol.y, 'LineWidth', 2);
set(gca, 'YLim', [0 3])
legend('CycET', 'CycAT', 'CycBT', 'Cdc20A');
xlabel('time (h)'), ylabel('concentration (AU)')
title('MATLAB cell cycle model')
