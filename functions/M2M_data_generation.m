function [rndmic,mydata,errordata,y_0,t_period,N,snaps,time] = M2M_data_generation(input)%(tF,N,snaps,sig,mexmodel)
% This function generates data/errordata for your model
%
%
% [Syntax]
% [ic,mydata,errordata,y_0,t_period,N,snaps,time] = data_generation
%
% [INPUT]
% See userinteraction
%
% [OUTPUT]
%   ic:           number: initial conditions (stored in your model)
%   mydata:       number: data simulated by your model
%   errordata:    number: data with noise
%   y_0:          number: statevalues at t = 0
%   t_period:     number: Period of the cell cycle for every single cell
%   N:            number: Number of cells
%   snaps:        number: Number of snapshots
%   time:         number: Timepoint of every single cell
% [EXAMPLE]
% Pending!

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
addpath(genpath('~/methods2models'));
tF = input.tF;
N = input.N;
snaps = input.snaps;
sig = input.sig;
mexmodel = input.mexmodel;
%% 2) Original statevalues -----------------------------------------------%
disp('Original statevalues -----------------------------------------------')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --> Check, if this code is correct!

[original_data,ic] = M2M_mexmodel(tF,[],mexmodel); %New M2M_mexmodel function here
original_statevalues = original_data.statevalues';

%% x) Calculate start of the cell cycle
locs = M2M_start(original_statevalues);
y_0 = original_statevalues(:,locs(6));%6=lb=lower bound
y_0(end+1)=2; % DNA = 2N at Cellcycle start

%% 3) Randomize IC -------------------------------------------------------%
disp('Randomize IC -------------------------------------------------------')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rndmic = lognrnd_ic(N,ic); % Generate gaussian distributed ICs

%% 4) Data generation-----------------------------------------------------%
disp('Data generation-----------------------------------------------------')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-----> Preallocation <--------%
simdata = cell(1,N);           %
random_statevalues = cell(1,N);%
%------------------------------%
for i = 1:N
    simdata{i} = M2M_mexmodel(tF,rndmic(:,i),mexmodel); %C-Model (MEX-File)
    random_statevalues{i} = simdata{1,i}.statevalues;%Extract the statevalues
end
%% 5) Measurement---------------------------------------------------------%
% disp('Measurement---------------------------------------------------------')
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
start=zeros(N,size(ic,1));
samples=zeros(N,snaps);
t_period=zeros(6,N);
for i = 1:N
    statevalues=random_statevalues{1,i};
    [START, SAMPLES,T_PERIOD] = M2M_timepoints(statevalues,snaps);
    start(i,:)=START;
    samples(i,:)=SAMPLES;
    t_period(:,i)=T_PERIOD;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%% 5.1) Test measurement (TEST IT!!!)
% disp('TEST Measurement!!!------------------------------------------------')
% [start, samples,t_period] = M2M_timepoints_template(random_statevalues,N,snaps);
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 6.1) Simulate the DNA separately --------------------------------------%

%% 6.2) Calculate cell cycle start

%% 6) Simulate the model--------------------------------------------------%
disp('Simulate the model--------------------------------------------------')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--> Preallocation <---------%
rndm_measurement = cell(1,N);%
measurement = cell(1,N);     %
MEASUREMENT=cell(1,N);       %
TSPAN = zeros(N,snaps+2);    %
DNA = zeros(snaps+2,N);      %
IDX= zeros(N,snaps);         %
%----------------------------%
for i = 1:N
    [sorted_samples,idx]=sort(samples(i,:),2);
    IDX(i,:)=idx;
%     tspan = horzcat(0,sort(samples(i,:),2),t_period(1,i)); % time vector from 0 to 30 (set t0 = 0)
    tspan = horzcat(0,sorted_samples,t_period(1,i)); % time vector from 0 to 30 (set t0 = 0)
    TSPAN(i,:) = tspan;%Time vektor (discrete)
    simIC = start(i,:); %Cdc20A =start = IC = t0 (with (1,:) only one period is used here)
    %--------------------------------------------------------------------------
    % NEW SIMULATION (SNAPSHOTS)

    rndm_measurement{i} = M2M_mexmodel(tspan,simIC,mexmodel);
    measurement{i} = rndm_measurement{1,i}.statevalues;
    %--------------------DNA Simulation----------------------------------------
    y_DNA = M2M_DNAsimulation(tspan,t_period(1,i),t_period(2,i), t_period(3,i))';
    DNA(:,i) = y_DNA;
    %--------------------------------------------------------------------------
    measurement{i} = horzcat(measurement{i},y_DNA)'; %Save statevalues only
%     measurement{i} = vertcat(measurement{i},tspan);
    MEASUREMENT{i} = measurement{i};
    measurement{i} = measurement{i}(:,2:end-1);%Remove the first and the last values (Necessary?)
    
end
mydata = cell2mat(measurement);
time = vertcat(TSPAN(:,2),TSPAN(:,3))';%Could result in an error if more than 2 snapshots...
%% 7) Error model (add noise to dataset) ---------------------------------%
disp('Error model (add noise to dataset) ---------------------------------')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is necessary to gain realistic results
errordata = M2M_error_model(mydata,sig);
%% 8) Write data to output struct (later)
end

