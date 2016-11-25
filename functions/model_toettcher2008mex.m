%% This is an MEX-model implementation of the IQM-model 
function [results_mex] = model_toettcher2008mex
% Create MEX-model
toettcher2008 = IQMmodel('model_toettcher2008.txt'); % Load the model
IQMmakeMEXmodel(toettcher2008,'model_toettcher2008MEX'); % Create a MEX simulation function


% Simulate the models
tic
results_mex = model_toettcher2008MEX(0:0.1:120); % Simulation of MEX-model
toc

tic
results_iqm = IQMsimulate(toettcher2008,0:0.1:120); % Simulation of IQM-model
toc

% Plot both simulations in one picture
%plot(results_mex.time,results_mex.statevalues,'k');
%hold on;
%plot(results_iqm.time,results_iqm.statevalues,'r--');
end
