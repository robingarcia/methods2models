function [input, data_gen] = M2M_data_generation(input)
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
doplots=input.doplots;
%% 2) Original statevalues -----------------------------------------------%
disp('Original statevalues -----------------------------------------------')
original_time=tic;
[original_data,ic] = M2M_mexmodel(tF,[],mexmodel);
original_statevalues = original_data.statevalues';
toc(original_time)

if doplots
   M2M_mexmodelP(original_data,statenames)
end
%% x) Calculate start of the cell cycle
disp('Calculate start of cell cylce -------------------------------------')
start_time=tic;
[~,lb,~] = M2M_start(original_statevalues);
y_0 = original_statevalues(:,lb);%lb=lower bound Why from original model???
y_0(end+1)=2; % DNA = 2N at Cellcycle start
toc(start_time)

if doplots
   M2M_startP(original_data,lb,statenames)
end
%% 3) Randomize IC -------------------------------------------------------%
disp('Randomize IC -------------------------------------------------------')
random_time=tic;
rndmic = M2M_lognrnd_ic(N,ic); % Generate gaussian distributed ICs
toc(random_time)

if doplots
   M2M_lognrnd_icP(rndmic,statenames)
end
%% 4) Data generation-----------------------------------------------------%
disp('Data generation-----------------------------------------------------')
generation_time=tic;
%-----> Preallocation <--------%
simdata = cell(1,N);           %
random_statevalues = cell(1,N);%
%------------------------------%
for i = 1:N %parfor?
    simdata{i} = M2M_mexmodel(tF,rndmic(:,i),mexmodel); %C-Model (MEX-File)
    random_statevalues{i} = simdata{1,i}.statevalues;%Extract the statevalues 
end

if doplots
   M2M_biovarianceP(simdata)
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

if doplots
   M2M_allstartP(simdata,UB,LB,PERIOD)
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
toc(generation_time)
t_period(1,:)=PERIOD;
t_period(2,:)=G1;
t_period(3,:)=S;
t_period(4,:)=G2;

if doplots
   M2M_durationP(simdata,t_period)
end
%% 5) Measurement---------------------------------------------------------%
disp('Measurement---------------------------------------------------------')
measure_time=tic;
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
toc(measure_time)
if doplots
    M2M_timepointsP(p_value,samples,snaps)
end
%% New IC for every cell (Why do you use y_0 and not start???)
newic_time=tic;
start=zeros(N,size(ic,1));
for i=1:N
    statevalues=random_statevalues{1,i};
    lb=LB(:,i);%lb = cellcycle start
cellcyclestart = statevalues(lb,:); %New IC from simulated dataset
start(i,:)=cellcyclestart;
end
toc(newic_time)
if doplots
   M2M_newICP() 
end
%% 6) Simulate the model--------------------------------------------------%
disp('Simulate the model--------------------------------------------------')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
simul_time=tic;
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
    [sorted_samples,idx]=sort(samples(i,:),2);%Timepoints = snapshots
    IDX(i,:)=idx;

    tspan = horzcat(0,sorted_samples,period);%New time vector
    TSPAN(i,:) = tspan;%Time vektor (discrete)
    simIC = start(i,:); %Cdc20A =start = IC = t0 (with (1,:) only one period is used here)
   
    %--------------------------------------------------------------------------
    % NEW SIMULATION (SNAPSHOTS)
% Persiod hier bestimmen?
    rndm_measurement{i} = M2M_mexmodel(tspan,simIC,mexmodel);
    measurement{i} = rndm_measurement{1,i}.statevalues;
    
    %--------------------DNA Simulation----------------------------------------
    y_DNA = M2M_DNAsimulation(tspan,g1,s)';

    DNA(:,i) = y_DNA;
    
    %--------------------------------------------------------------------------
    measurement{i} = horzcat(measurement{i},y_DNA)'; %Add the DNA
    MEASUREMENT{i} = measurement{i};
    MEASUREMENT{i} = vertcat(MEASUREMENT{i},tspan);
    measurement{i} = measurement{i}(:,2:end-1);%Remove the first and the last values (Necessary?)
    MEASUREMENT{i} = MEASUREMENT{i}(:,2:end-1);%Remove the first and the last values (Necessary?)

end
mydata = cell2mat(measurement);%DNA
MYDATA = cell2mat(MEASUREMENT);%DNA + time
time = vertcat(TSPAN(:,2),TSPAN(:,3))';%Could result in an error if more than 2 snapshots...
toc(simul_time)
if doplots
    M2M_measurementP(MYDATA,statenames)
end
%% 7) Error model (add noise to dataset) ---------------------------------%
% sig = big(more noise), small(less noise)
disp('Error model (add noise to dataset) ---------------------------------')
error_time=tic;
% This is necessary to gain realistic results
errordata = M2M_error_model(mydata,sig);
toc(error_time)

if doplots
    M2M_error_modelP(mydata,errordata,statenames)
end
%% Purge datasets ---------------------------------------------------------
disp('Purge dataset ---------------------------------')
purge_time=tic;
[errordata,~,nzero] = M2M_purge(errordata);
[mydata,~,~] = M2M_purge(mydata);
[MYDATA,~,~] = M2M_purge(MYDATA);
[rndmic, ~] = M2M_purge(rndmic);
[y_0, ~] = M2M_purge(y_0);
statenames = statenames(nzero);
toc(purge_time)
%% 8) Store the results in a struct
disp('Store results in a struct---------------------------------')
store_time=tic;
data_gen=([]);
data_gen.rndmic=rndmic;
data_gen.mydata=mydata;
data_gen.errordata=errordata;
data_gen.y_0=y_0;
data_gen.t_period=t_period;
data_gen.MYDATA=MYDATA;
data_gen.time=time;
data_gen.statenames=statenames;
toc(store_time)
end

