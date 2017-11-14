function  [results_mex,IC]=M2M_mexmodel(time_vector, IC,mexmodel) 
%This function use your MEX model for simulation
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
%
% [EXAMPLE]
% IC = mexmodel();
% results_mex = mexmodel(0:1000,IC);

%==========================================================================
%     methods2models
%     Copyright (C) 2017  Robin Garcia Victoria
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%==========================================================================
if isempty(IC)
IC = mexmodel();
else 
end
results_mex = mexmodel(time_vector,IC); % Simulation of MEX-model
end

