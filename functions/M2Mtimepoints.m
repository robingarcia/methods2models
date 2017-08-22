function [START, samples,T,G,GAMMMA] = M2Mtimepoints(random_statevalues,t_iqm,o,N,m)
% This is an template for output generation
% This function generates the snapshots
% 
% [SYNTAX]
% [START, samples,T,G,GAMMMA] = timepoints_template(random_statevalues,t_iqm,o)
% 
% [INPUTS]
% random_statevalues
% t_iqm
% o
% 
% [OUTPUTS]
% START
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

%t = t_iqm; % Time
%N = length(statevalues); % Determine the number of cells
%p = length(t);
%statevalues_cut = cell(1,N);
%for i = 1:N
    p = length(statevalues);
statevalues_cut = statevalues((o:p),:); % Cut your dataset
%end
%% Determine the peaks of your Cyclines and APC during cellcycle
j = [2,3,4,5,6,7,12]; %States which should be analyzed
F = cell(5,length(j));
G = cell(4,N);
T = zeros(3,N);
Tstart = zeros(1,N);
for i = 1:N        % i = Number of cells
    for k = 6
        [~,locs2]=findpeaks(statevalues((o:p),k));
        for j = [2,3,4,5,7,12]    % j = States
    
    [~,locs, widths, proms]=findpeaks(statevalues_cut((locs2(end-1):locs2(end)),j),'MinPeakHeight',0.05);
    
    AverageDistance_Peaks = diff(locs2);
    AverageDistance_Peaks = AverageDistance_Peaks(end);
    %F{1,j} = pks;        %Peakvalue
    F{2,j} = locs;       %Position
    F{3,j} = widths;     %
    F{4,j} = proms;      %Prominence
    F{5,j} = AverageDistance_Peaks;
    F{6,k} = locs2;
    G{1,i} = F;
    
    %Calculate the periods of all proteins
    
    
        end
    end
    T(1,i)=locs2(end)-locs2(end-1); %APC Period (=Cellcycle period)
    Tstart(1,i) = locs2(end-1);
    
    CycETransEnd = G{1,i}{2,5}-1;
    
    pBTransEnd = G{1,i}{2,4}-1;
    
    % Duration G1-Phase
    g1Duration = CycETransEnd; %- Cdc20ATransMinus;
    
    T(2,i) = g1Duration/T(1,i);
    
    sDuration = pBTransEnd; %- Cdc20ATransMinus;
    
    T(3,i) = sDuration/T(1,i); %G{1, i}{5, 6};
end

%% Inverse method alorithm
    %m = 2;
    %samples = zeros(N,m);%n=cells and m = timepoints
    
    %GAMMMA = zeros(1,N); %Just preallocation
    %for i = 1:N
        gammma = log(2)/T(1,i); % G{2,i}; % G{2,i} is the period!
        GAMMMA = gammma;
    
    P = rand(1,m);% Number of cells (=n) or time (=m)?
    
    x=@(P,gammma)((log(-2./(P-2))/gammma));
    samples = x(P,gammma); %ceil or round
    %end   
%% New simulated IC (extracted from a simulation = cellcycle start)
%START = cell(2,N);
%for i = 1:N
    startpoint = Tstart(1,i); %Choose 3-4 periods (But only one period is required here!)
    %START{1,i} = startpoint-1; % Startpoints of the cellcycle

             A = statevalues_cut;
        
        START = A(startpoint-1,:); %New IC from simulated dataset
%end
end
