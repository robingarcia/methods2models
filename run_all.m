function [] = run_all
%% User inputs ------------------------------------------------------------
[filename,tF,lb,n,ic]=userinteraction;
%% -------------------Data generation--------------------------------------

rndmic = lognrnd_ic(n,ic); % Generate gaussian distributed ICs
simdata = cell(1,n);
random_statevalues = cell(1,n);
for i = 1:n
  simdata{i} = model_toettcher2008MEX(tF,rndmic{i}); %C-Model (MEX-File)
  random_statevalues{i} = simdata{1,i}.statevalues;%Extract the statevalues
end
%% ---------------------Measurement----------------------------------------

[START, SAMPLES,t_period] = timepoints_template(random_statevalues, tF, lb);
%% ------------------Simulate the model------------------------------------

m = size(SAMPLES,2);
rndm_measurement = cell(1,n);
measurement = cell(1,n);
TSPAN = zeros(n,m+2);
%proport = zeros(n,1);
samples = SAMPLES;
for i = 1:n 
    tspan = horzcat(0,sort(samples(i,:),2),t_period(1,i)); % time vector from 0 to 30 (set t0 = 0)
    TSPAN(i,:) = tspan;
    simulationIC = START{2,i}; %APC peak = start = IC = t0 (with (1,:) only one period is used here)
%--------------------------------------------------------------------------
% NEW SIMULATION (SNAPSHOTS)
rndm_measurement{i} = model_toettcher2008MEX(tspan,simulationIC);
measurement{i} = rndm_measurement{1,i}.statevalues;
%--------------------DNA Simulation----------------------------------------
y_DNA = DNAcontent(tspan,t_period(1,i),t_period(2,i), t_period(3,i))';
%--------------------------------------------------------------------------
measurement{i} = horzcat(measurement{i},y_DNA)'; %Save statevalues only
measurement{i} = measurement{i}(:,2:end-1);
end
mydata = cell2mat(measurement);
%% Error model (add noise to dataset) -------------------------------------

% This is necessary to gain realistic results
errordata = error_model(mydata);
%Cmatrix = cell(m,n);

%% Calculate C-Matrix -----------------------------------------------------
cmatrix = Cmatrix;
for i = 1:length(errordata)
    measurementdata(:,i) = cmatrix * errordata(:,i);
end
%% Save workspace
cd('~/methods2models/datasets/output/');
save([filename '.mat'],'mydata','errordata', '-v7.3');
cd('~/methods2models/')
end
