%% Script for model verification

% Extraction of the results m.-Model
results_m=final_model_modified();
y_T = transpose(results_m.y);
x_T = transpose(results_m.x);

% Extraction of the results IQM
%results_iqm = model_toettcher2008iqm();
toettcher2008 = IQMmodel('model_toettcher2008.txt');
toettcher2008 = IQMsimulate(toettcher2008, x_T);
y_iqm = toettcher2008.statevalues;
x_iqm = toettcher2008.time;
y_iqmt= transpose(toettcher2008.statevalues);
x_iqmt= transpose(toettcher2008.time);
% Calculate the difference of the outputs between the 2 models
%diffi_1 = y_T - y_iqm;
%diffi_2 = y_iqm - y_T;
result = y_T==y_iqm; % y_T = States from Toettcher , y_iqm = States from IQM-Model 
figure(5)
[r,c] = size(result);                           % Get the matrix size
imagesc((1:c)+0.5,(1:r)+0.5,result);            % Plot the image
colormap(gray);                              % Use a gray colormap
axis equal                                   % Make axes grid sizes equal
set(gca,'XTick',1:(c+1),'YTick',1:(r+1),...  % Change some axes properties
        'XLim',[1 c+1],'YLim',[1 r+1],...
        'GridLineStyle','-','XGrid','on','YGrid','on');
% b - a matrix defining some outputs for plotting
b = zeros(4, 31);
b(1,[3 4 9 10 30]) = 1; % CycBT
b(2,[2 15 29]) = 1;        % CycAT
b(3,[5 16 31]) = 1;        % CycET
b(4,12) = 1;               % Cdc20A

figure(4)
plot(x_iqmt, b*y_iqmt, 'LineWidth', 2);
set(gca, 'YLim', [0 3])
legend('CycET', 'CycAT', 'CycBT', 'Cdc20A');
xlabel('time (h)'), ylabel('concentration (AU)')
title('Zellzyklusmodell in IQM implementiert')

% Plot IQM
%figure(3)
%plot(x_iqm,y_iqm);
