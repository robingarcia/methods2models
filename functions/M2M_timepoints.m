function [start, samples,T] = M2M_timepoints(random_statevalues,N,snaps)
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
%% Load the data
statevalues = random_statevalues; % States
%% Determine the peaks of your Cyclines and APC during cellcycle
% j = [4,5]; %States which should be analyzed
% F = zeros(1,j(end));
%----------T = zeros(6,N);
%-------------------Tstart = zeros(1,N);
% for i = 1:N        % i = Number of cells
%     [TT,tstart] = M2M_duration(statevalues{1,i});
        [T,tstart] = M2M_duration(statevalues);

%     T(:,i)=TT;
%     Tstart(1,i) = tstart;
% end
%% Inverse method alorithm (Remove the loop --> 29.08.2017)
% samples = zeros(N,snaps);%N=cells and snaps = # timepoints
% P_value = zeros(N,snaps);% Delete this?
start = zeros(N,size(random_statevalues{1,1},2));%Correct???
%     for i = 1:N
%         gammma = log(2)/T(1,i); % T (1,i) is the period of the cell cycle!
        gammma = log(2)/T; % T (1,i) is the period of the cell cycle!

        P = rand(1,snaps);% Number of cells (=n) or time (=m)?
        x=@(P,gammma)((log(-2./(P-2))/gammma));
%         samples(i,:) = x(P,gammma); %ceil or round
                samples = x(P,gammma); %ceil or round
%         P_value(i,:) = P;   
%% New simulated IC (extracted from a simulation = cellcycle start)
%     startpoint = Tstart(1,i); %Choose 3-4 periods (But only one period is required here!)
        startpoint = tstart; %Choose 3-4 periods (But only one period is required here!)

        A = statevalues{1,i};
    start(i,:) = A(startpoint,:); %New IC from simulated dataset
%     end
end
