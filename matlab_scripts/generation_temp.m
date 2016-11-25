%% Script for data generation with autosave function

%Load IQM-model


% Simulate model and generate data with default IC values
%toettcher2008_sim = IQMsimulate(toettcher2008,120); %simulation time = 120

% Fetch the IC vector
%IC_default = IQMinitialconditions(toettcher2008); %IC-vector w/ default IC


tic
% for-Loop
n = zeros(1,1); % Define a zero matrix --> better performance
for n = 1:1 % n = number of run
random_out(n) = random_ic;

% Change the IC randomly
%a = 0.00000000000000; %Lower bound
%b = 1.00000000000000; %Upper bound
%IC_rndm = (b-a).*rand(1,31) + a; %Create random IC
%IC_rndm_range = [min(IC_rndm) max(IC_rndm)]; %Determine extreme IC-values

%Update the IQM-model with new IC values
%toettcher2008_ICupdate = IQMinitialconditions(toettcher2008,IC_rndm);

%Simulate and generate data w/ new IC values (Random)
%toettcher2008_sim_update = IQMsimulate(toettcher2008_ICupdate,120);
%end

%Autosave dataset
%workspace_backup = '~/methods2models/datasets/workspace_backup.mat';
%save(workspace_backup); %Backup of workspace
%save IC_up 
%run = '~/methods2models/datasets/statevalues_backup.mat';
%save('~/methods2models/datasets/random_output.mat');
% Dataset2Wanderlust

% Autosave Wanderlust


%Profile output
%profile viewer
end
toc

% Define updated statevalues
random_statevalues = random_out.statevalues;
random_statevalues_T = transpose(random_statevalues);
%newdata = transpose(random_statevalues);
%Save statevalues as dataset
save ~/methods2models/datasets/random_output.mat random_statevalues_T;
%save ~/methods2models/datasets/example/data.mat newdata;


% Default IC
%default = random_ic();

%Plot the dataset in all combinations (Statevalue, n outputs)
for x=1:3
    for y=1:3
figure(x)
scatterplot(x,y) = scatter(random_statevalues_T(x,:),random_statevalues_T(y,:))
    end
end

