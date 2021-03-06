function [results_mex,IC] = model_toettcher2008mex(time_vector,IC)
%%This is an MEX-model implementation of the IQM-model 
%This function creates a MEX-Model (C-Code) from a IQM-Model
% To run this function some prerequisites are required:
% 
% 1) Model stored as IQM-Model (yourmodel.txt)
% Check the docs of IQM toolbox how to create a IQM-Model
% 
% [SYNTAX]
% [results_mex] = model_toettcher2008mex(time_vector, IC)
% 
% [INPUTS]
% time_vector        number:number: The interval from 0 to tmax
% IC                 number: The initial conditions
% 
% [OUTPUTS]
% results_mex         struct:Results of the simulation
%--------------------------------------------------------------------------


% % Create MEX-model
% cd '~/methods2models/IQM-Projektordner/models/mex_model';
% toettcher2008 = IQMmodel('~/methods2models/IQM-Projektordner/models/model_toettcher2008.txt'); % Load the model
% IQMmakeMEXmodel(toettcher2008,'model_toettcher2008MEX'); % Create a MEX simulation function
% cd '~/methods2models/';
if isempty(IC)
IC = model_toettcher2008MEX;
else 
end
results_mex = model_toettcher2008MEX(time_vector,IC); % Simulation of MEX-model


% % m - a matrix defining some outputs for plotting (MEX-Model)
% m = zeros(4, 31);
% m(1,[3 4 9 10 30]) = 1;    % CycBT
% m(2,[2 15 29]) = 1;        % CycAT
% m(3,[5 16 31]) = 1;        % CycET
% m(4,12) = 1;               % Cdc20A
% 
% figure(76)
% plot(transpose(results_mex.time), m*transpose(results_mex.statevalues), 'LineWidth', 2);
% set(gca, 'YLim', [0 3])
% legend('CycET', 'CycAT', 'CycBT', 'Cdc20A');
% xlabel('time (h)'), ylabel('concentration (AU)')
% title('MEX cell cycle model')

% Plot both simulations in one picture
%plot(results_mex.time,results_mex.statevalues,'k');
%hold on;
%plot(results_iqm.time,results_iqm.statevalues,'r--');
end
