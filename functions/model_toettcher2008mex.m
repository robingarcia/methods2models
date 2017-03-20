%% This is an MEX-model implementation of the IQM-model 
function [results_mex] = model_toettcher2008mex(time_vector, IC)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Debugging area
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Create MEX-model
%cd '~/methods2models/IQM-Projektordner/models/mex_model';
%toettcher2008 = IQMmodel('~/methods2models/IQM-Projektordner/models/model_toettcher2008.txt'); % Load the model
%IQMmakeMEXmodel(toettcher2008,'model_toettcher2008MEX'); % Create a MEX simulation function
%ICdefault = IQMinitialconditions(toettcher2008);
%cd '~/methods2models/';
%t_iqm = 0:0.1:100;
%time_vector = 0:0.1:100;
% Simulate the models
%tic
%results_iqm = IQMsimulate(toettcher2008,0:0.1:120); % Simulation of IQM-model
%toc

tic
results_mex = model_toettcher2008MEX(time_vector,IC); % Simulation of MEX-model
%results_mex = model_toettcher2008MEX(t_iqm, ICdefault); % Simulation of MEX-model
toc

% m - a matrix defining some outputs for plotting (MEX-Model)
m = zeros(4, 31);
m(1,[3 4 9 10 30]) = 1;    % CycBT
m(2,[2 15 29]) = 1;        % CycAT
m(3,[5 16 31]) = 1;        % CycET
m(4,12) = 1;               % Cdc20A

figure(76)
plot(transpose(results_mex.time), m*transpose(results_mex.statevalues), 'LineWidth', 2);
set(gca, 'YLim', [0 3])
legend('CycET', 'CycAT', 'CycBT', 'Cdc20A');
xlabel('time (h)'), ylabel('concentration (AU)')
title('MEX cell cycle model')

% Plot both simulations in one picture
%plot(results_mex.time,results_mex.statevalues,'k');
%hold on;
%plot(results_iqm.time,results_iqm.statevalues,'r--');
end
