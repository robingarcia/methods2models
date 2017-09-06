function [cellcyclestart, samples] = M2M_timepoints(statevalues,snaps,start,period)
% This is an template for output generation
% This function generates the snapshots
% 
% [SYNTAX]
% [START, samples,T] = M2M_timepoints(random_statevalues,t_iqm,o)
% 
% [INPUTS]
% random_statevalues
% t_iqm
% o
% 
% [OUTPUTS]
% START        New IC's 
% samples
% T
% G
% GAMMMA

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

%% Inverse method alorithm (Remove the loop --> 29.08.2017)
omega = log(2)/period; % period = period of the cell cycle
P = rand(1,snaps);
x=@(P,omega)((log(-2./(P-2))/omega));
samples = x(P,omega);
%         P_value(i,:) = P;   
%% New simulated IC (extracted from a simulation = cellcycle start)
cellcyclestart = statevalues(start,:); %New IC from simulated dataset
end
