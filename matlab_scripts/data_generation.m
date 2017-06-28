function [ic,mydata,errordata,y_0,t_period,N,snaps,time] = data_generation(tF,lb,N,snaps,sig)
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
addpath(genpath('~/methods2models'));
%load('toettcher_statenames.mat');
%% 1) User inputs --------------------------------------------------------%
% disp('User inputs --------------------------------------------------------')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [~,tF,lb,N,snaps,sig]=userinteraction;
%% 2) Original statevalues -----------------------------------------------%
% disp('Original statevalues -----------------------------------------------')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[original_data,ic] = model_toettcher2008mex(tF,[]);
original_statevalues = original_data.statevalues';
[~,locs_apc] = findpeaks(original_statevalues(6,:));
y_0 = original_statevalues(:,locs_apc(end));
y_0(end+1)=2; % DNA = 2N at Cellcycle start
%% 3) Randomize IC -------------------------------------------------------%
% disp('Randomize IC -------------------------------------------------------')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rndmic = lognrnd_ic(N,ic); % Generate gaussian distributed ICs
%--> Loop detected! (Results stored in a CELL!)
%% 4) Data generation-----------------------------------------------------%
% disp('Data generation-----------------------------------------------------')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-----> Preallocation <--------%
simdata = cell(1,N);           %
random_statevalues = cell(1,N);%
%------------------------------%
for i = 1:N
    simdata{i} = model_toettcher2008mex(tF,rndmic(:,i)); %C-Model (MEX-File)
    random_statevalues{i} = simdata{1,i}.statevalues;%Extract the statevalues
end
%Loop detected! (Results stored in a CELL!)
%% 5) Measurement---------------------------------------------------------%
% disp('Measurement---------------------------------------------------------')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[start, samples,t_period] = timepoints_template(random_statevalues,lb,N,snaps);
% Attention: Use N as input for timepoints!!!
% --> Many loops detected within timepoints!
%% 6) Simulate the model--------------------------------------------------%
% disp('Simulate the model--------------------------------------------------')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--> Preallocation <---------%
%m = size(samples,2);        %
rndm_measurement = cell(1,N);%
measurement = cell(1,N);     %
TSPAN = zeros(N,snaps+2);    %
%----------------------------%
for i = 1:N
    tspan = horzcat(0,sort(samples(i,:),2),t_period(1,i)); % time vector from 0 to 30 (set t0 = 0)
    TSPAN(i,:) = tspan;
    simulationIC = start(i,:); %APC peak = start = IC = t0 (with (1,:) only one period is used here)
    %--------------------------------------------------------------------------
    % NEW SIMULATION (SNAPSHOTS)
    rndm_measurement{i} = model_toettcher2008mex(tspan,simulationIC);
    measurement{i} = rndm_measurement{1,i}.statevalues;
    %--------------------DNA Simulation----------------------------------------
    y_DNA = DNAcontent(tspan,t_period(1,i),t_period(2,i), t_period(3,i))';
    %--------------------------------------------------------------------------
    measurement{i} = horzcat(measurement{i},y_DNA)'; %Save statevalues only
    measurement{i} = measurement{i}(:,2:end-1);
end
mydata = cell2mat(measurement);
time = vertcat(TSPAN(:,2),TSPAN(:,3))';%Could result in an error if more than 2 snapshots...
%% 7) Error model (add noise to dataset) ---------------------------------%
% disp('Error model (add noise to dataset) ---------------------------------')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is necessary to gain realistic results
errordata = error_model(mydata,sig);
%% 8) Write data to output struct (later)
end

