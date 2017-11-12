%Simulate IQM-Model
function [toet2008, toettcher2008, ICdefault] = model_toettcher2008iqm(time_vector)

toettcher2008 = IQMmodel('model_toettcher2008.txt'); %Load the model
ICdefault = IQMinitialconditions(toettcher2008);
%toet2008 = IQMsimulate(toettcher2008,time_vector); %Simulate the loaded model
toet2008 = IQMsimulate(toettcher2008, 1000); %Simulate the loaded model


% b - a matrix defining some outputs for plotting (IQM-Model)
b = zeros(4, 31);
b(1,[3 4 9 10 30]) = 1;    % CycBT
b(2,[2 15 29]) = 1;        % CycAT
b(3,[5 16 31]) = 1;        % CycET
b(4,12) = 1;               % Cdc20A

figure(4)
plot(transpose(toet2008.time), b*transpose(toet2008.statevalues), 'LineWidth', 2);
set(gca, 'YLim', [0 3])
legend('CycET', 'CycAT', 'CycBT', 'Cdc20A');
xlabel('time (h)'), ylabel('concentration (AU)')
title('IQM cell cycle model')
end

