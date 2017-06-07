function [ic,mydata,errordata,y_0,t_period,N,snaps] = data_generation
%profile on
addpath(genpath('~/methods2models'));
%load('toettcher_statenames.mat');
%% 1) User inputs --------------------------------------------------------%
disp('User inputs --------------------------------------------------------')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[~,tF,lb,N,ic,snaps,sig]=userinteraction;

%% 2) Original statevalues -----------------------------------------------%
disp('Original statevalues -----------------------------------------------')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%original_data = model_toettcher2008MEX(tF,ic);
tic
original_data = model_toettcher2008mex(tF,ic);
original_statevalues = original_data.statevalues';
[~,locs_apc] = findpeaks(original_statevalues(6,:));
y_0 = original_statevalues(:,locs_apc(end));
y_0(end+1)=2; % DNA = 2N at Cellcycle start
% --> No loop detected!
toc
%% 3) Randomize IC -------------------------------------------------------%
disp('Randomize IC -------------------------------------------------------')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
rndmic = lognrnd_ic(N,ic); % Generate gaussian distributed ICs
toc
%--> Loop detected! (Results stored in a CELL!)
%% 4) Data generation-----------------------------------------------------%
disp('Data generation-----------------------------------------------------')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-----> Preallocation <--------%
simdata = cell(1,N);           %
random_statevalues = cell(1,N);%
%------------------------------%
tic
for i = 1:N
  simdata{i} = model_toettcher2008mex(tF,rndmic(:,i)); %C-Model (MEX-File)
  random_statevalues{i} = simdata{1,i}.statevalues;%Extract the statevalues
end
toc
%Loop detected! (Results stored in a CELL!)
%% 5) Measurement---------------------------------------------------------%
disp('Measurement---------------------------------------------------------')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
[start, samples,t_period] = timepoints_template(random_statevalues,lb,N,snaps);
toc
% Attention: Use N as input for timepoints!!!
% --> Many loops detected within timepoints!
%% 6) Simulate the model--------------------------------------------------%
disp('Simulate the model--------------------------------------------------')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--> Preallocation <---------%
%m = size(samples,2);         %
rndm_measurement = cell(1,N);%
measurement = cell(1,N);     %
%TSPAN = zeros(N,m+2);        %
%----------------------------%
tic
for i = 1:N 
    tspan = horzcat(0,sort(samples(i,:),2),t_period(1,i)); % time vector from 0 to 30 (set t0 = 0)
    %TSPAN(i,:) = tspan;
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
toc
mydata = cell2mat(measurement);

%% 7) Error model (add noise to dataset) ---------------------------------%
disp('Error model (add noise to dataset) ---------------------------------')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is necessary to gain realistic results
tic
errordata = error_model(mydata,sig);
toc

%% 8) Write data to output struct (later)
end

