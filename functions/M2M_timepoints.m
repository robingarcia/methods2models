function [start, samples,T] = M2M_timepoints(statevalues,snaps)
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

%% Determine the peaks of your Cyclines and APC during cellcycle
[T,tstart] = M2M_duration(statevalues);
%% Inverse method alorithm (Remove the loop --> 29.08.2017)
gammma = log(2)/T(1); % T (1,i) is the period of the cell cycle!
P = rand(1,snaps);% Number of cells (=n) or time (=m)?
x=@(P,gammma)((log(-2./(P-2))/gammma));
samples = x(P,gammma); %ceil or round
%         P_value(i,:) = P;   
%% New simulated IC (extracted from a simulation = cellcycle start)
start = statevalues(tstart,:); %New IC from simulated dataset
end
