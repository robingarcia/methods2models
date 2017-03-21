%% Run all in one step
%addpath(genpath('~/methods2models'));
%tic
filename = datestr(now,30); %Timestamp
dt = input('Input stepzise (e.g: [0.1]):');
tmax = input('Input simulation time (e.g: [100]):');
tF = 0:dt:tmax; % Simulation Time
n = input('How many cells? (e.g: [20]):');           % n new datasets
% ----------------------------------------------------------Data generation
tic
rndmic = lognrnd_ic(n);
toc

tic
simdata = cell(1,n);
random_statevalues = cell(1,n);
for i = 1:n
   this_IC = rndmic{i};
   simdata{i} = model_toettcher2008MEX(tF,this_IC); %MEX or mex?
   %simdata{i} = model_toettcher2008MEX(t_iqm,this_IC); %MEX or mex? 
   random_statevalues{i} = simdata{1,i}.statevalues;
end
toc
% --------------------------------------------------------------Measurement
tic
[measurement, START, SAMPLES] = timepoints_template(random_statevalues, tF);
toc
%--------------------------------------------------------Simulate the model
tic
%rndm_measurement = cell(1,length(SAMPLES));
%for i = 1:length(SAMPLES)
    tF = sort(SAMPLES{1,i});
    simulationIC = START{2,1}(1,:);
    simulationIC = simulationIC([1:31]);
%rndm_measurement{i} = model_toettcher2008MEX(tF,simulationIC);
rndm_measurement = model_toettcher2008MEX(tF,simulationIC);

%end
toc
%

%%
% Build workspace


% Save workspace
%Save workspace w/ timestamp (Save statevalues only)
%directoryname = uigetdir('~/methods2models/');
cd('~/methods2models/datasets/');
%save(['~/methods2models/datasets/' filename '.mat'], 'random_statevalues', '-v7.3');
%save([filename '.mat'], 'random_statevalues','t_iqm','SAMPLES','rndm_measurement', '-v7.3');
save([filename '.mat'],'rndm_measurement');
cd('~/methods2models')
%toc
