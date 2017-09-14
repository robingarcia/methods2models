function [storage] = M2M_data_generation(input)%(tF,N,snaps,sig,mexmodel)
% function [rndmic,mydata,errordata,y_0,t_period,N,snaps,time] = M2M_data_generation(input)%(tF,N,snaps,sig,mexmodel)
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
statenames=input.statenames;
%% 2) Original statevalues -----------------------------------------------%
disp('Original statevalues -----------------------------------------------')
[original_data,ic] = M2M_mexmodel(tF,[],mexmodel);
original_statevalues = original_data.statevalues';

%% x) Calculate start of the cell cycle
[~,lb,~] = M2M_start(original_statevalues);
y_0 = original_statevalues(:,lb);%6=lb=lower bound
y_0(end+1)=2; % DNA = 2N at Cellcycle start

%% 3) Randomize IC -------------------------------------------------------%
disp('Randomize IC -------------------------------------------------------')
rndmic = M2M_lognrnd_ic(N,ic); % Generate gaussian distributed ICs

%% 4) Data generation-----------------------------------------------------%
disp('Data generation-----------------------------------------------------')
%-----> Preallocation <--------%
simdata = cell(1,N);           %
random_statevalues = cell(1,N);%
%------------------------------%
for i = 1:N
    simdata{i} = M2M_mexmodel(tF,rndmic(:,i),mexmodel); %C-Model (MEX-File)
    random_statevalues{i} = simdata{1,i}.statevalues;%Extract the statevalues
%     random_statevalues{i} = 
end

%% Start for every single cell (START)
UB=zeros(1,N);
LB=zeros(1,N);
PERIOD=zeros(1,N);
for i=1:N
    statevalues=random_statevalues{1,i}';
    [ub,lb,period]=M2M_start(statevalues);
    UB(:,i)=ub;
    LB(:,i)=lb;
    PERIOD(:,i)=period;
end

%% Cell cycle phases (DURATION)
G1=zeros(1,N);
S=zeros(1,N);
G2=zeros(1,N);
t_period=zeros(4,N);
for i=1:N
        statevalues=random_statevalues{1,i};
        ub=UB(:,i);%tF(UB(:,i));
        lb=LB(:,i);
        period=PERIOD(:,i);
        [g1,s,g2] = M2M_duration(statevalues,ub,lb,period);
        G1(:,i)=tF(g1);
        S(:,i)=tF(s);
        G2(:,i)=tF(g2);
        PERIOD(:,i)=tF(period);
end

t_period(1,:)=PERIOD;
t_period(2,:)=G1;
t_period(3,:)=S;
t_period(4,:)=G2;

%% 5) Measurement---------------------------------------------------------%
disp('Measurement---------------------------------------------------------')
% start=zeros(N,size(ic,1));
samples=zeros(N,snaps);
p_value=zeros(N,snaps);
% t_period=zeros(6,N);
for i = 1:N 
    period=PERIOD(:,i);
    [SAMPLES,P] = M2M_timepoints(snaps,period);
    samples(i,:)=SAMPLES;
    p_value(i,:)=P;
end

%% New IC for every cell 
start=zeros(N,size(ic,1));
for i=1:N
    statevalues=random_statevalues{1,i};
    lb=LB(:,i);%lb = cellcycle start
cellcyclestart = statevalues(lb,:); %New IC from simulated dataset
start(i,:)=cellcyclestart;
end
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
    period=PERIOD(:,i);
    g1=G1(:,i);
    s=S(:,i);
    [sorted_samples,idx]=sort(samples(i,:),2);
    IDX(i,:)=idx;

    tspan = horzcat(0,sorted_samples,period);
    TSPAN(i,:) = tspan;%Time vektor (discrete)
    simIC = start(i,:); %Cdc20A =start = IC = t0 (with (1,:) only one period is used here)
    
    %--------------------------------------------------------------------------
    % NEW SIMULATION (SNAPSHOTS)
% Persiod hier bestimmen?
    rndm_measurement{i} = M2M_mexmodel(tspan,simIC,mexmodel);
    measurement{i} = rndm_measurement{1,i}.statevalues;
    
    %--------------------DNA Simulation----------------------------------------

    y_DNA = M2M_DNAsimulation(tspan,period,g1,s)';

    DNA(:,i) = y_DNA;
    %--------------------------------------------------------------------------
    measurement{i} = horzcat(measurement{i},y_DNA)'; %Add the DNA
    MEASUREMENT{i} = measurement{i};
    MEASUREMENT{i} = vertcat(MEASUREMENT{i},tspan);
    measurement{i} = measurement{i}(:,2:end-1);%Remove the first and the last values (Necessary?)
    MEASUREMENT{i} = MEASUREMENT{i}(:,2:end-1);%Remove the first and the last values (Necessary?)

end
mydata = cell2mat(measurement);
MYDATA = cell2mat(MEASUREMENT);
time = vertcat(TSPAN(:,2),TSPAN(:,3))';%Could result in an error if more than 2 snapshots...
%% 7) Error model (add noise to dataset) ---------------------------------%
disp('Error model (add noise to dataset) ---------------------------------')

% This is necessary to gain realistic results
errordata = M2M_error_model(mydata,sig);

%% Purge datasets ---------------------------------------------------------
[errordata,~,nzero] = M2M_purge(errordata);
[rndmic, ~] = M2M_purge(rndmic);
[y_0, ~] = M2M_purge(y_0);
statenames = statenames(nzero);
%% 8) Store the results in a struct
storage=([]);
storage.rndmic=rndmic;
storage.mydata=mydata;
storage.errordata=errordata;
storage.y_0=y_0;
storage.t_period=t_period;
storage.MYDATA=MYDATA;
storage.time=time;
storage.statenames=statenames;
end

