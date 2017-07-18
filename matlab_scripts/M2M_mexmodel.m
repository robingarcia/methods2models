function  [results_mex,IC]=M2M_mexmodel(time_vector, IC,mexmodel)
%%This is an MEX-model implementation of the IQM-model 
%This function creates a MEX-Model (C-Code) from a IQM-Model
% To run this function some prerequisites are required:
% 
% 1) Model stored as IQM-Model (yourmodel.txt)
% Check the docs of IQM toolbox how to create a IQM-Model
% 
% [SYNTAX]
% [results_mex] = M2M_mexmodel(time_vector, IC)
% 
% [INPUTS]
% time_vector        number:number: The interval from 0 to tmax
% IC                 number: The initial conditions
% 
% [OUTPUTS]
% results_mex         struct:Results of the simulation
%--------------------------------------------------------------------------
if isempty(IC)
IC = mexmodel();
else 
end
results_mex = mexmodel(time_vector,IC); % Simulation of MEX-model
end

