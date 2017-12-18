function [samples, P] = M2M_timepoints(snaps,period)%(statevalues,snaps,start,period)
% This function generates the snapshots. 
% 
% [SYNTAX]
% [samples,P] = M2M_timepoints(snaps,period)
% 
% [INPUTS]
% snaps         Number of snapshots
% period        Cell cycle length
% 
% 
% [OUTPUTS]
% samples       New random numbers which follows a particular distribution
% P             Uniform distributed random numbers

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

%% Inverse method alorithm
omega = log(2)/period; % period = period of the cell cycle
P = rand(1,snaps);
x=@(P,omega)((log(-2./(P-2))/omega));
samples = x(P,omega);
%% New simulated IC (extracted from a simulation = cellcycle start)
% cellcyclestart = statevalues(start,:); %New IC from simulated dataset
end
