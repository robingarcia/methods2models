%% Function for random IC
function [toettcher2008_sim_update, results_mex_update] = lognrnd_ic

% Load model
toettcher2008 = IQMmodel('model_toettcher2008.txt');
%toettcher2008_sim = model_toettcher2008iqm(120);
% Simulate IQM model and generate data with default IC values
toettcher2008sim = IQMsimulate(toettcher2008,120); %simulation time = 120

% Fetch the IC vector
ICdefault = IQMinitialconditions(toettcher2008); %IC-vector w/ default IC

%Fetch the parameter vector
[parameters,values]=IQMparameters(toettcher2008); %Parameter-vector w/ deafault parameters
Pdefault = values; 

% Simulate MEX model and generate data with default values
modeltoettcher2008simex = model_toettcher2008MEX(0:120); %simulation time = 120
resultsmex = modeltoettcher2008simex(toettcher2008sim.time, ICdefault, Pdefault);

% Change the IC value log normally distributed
sigma = 1;
M = ICdefault;
V = sigma * ICdefault;
MU = log(M^2 / sqrt(V+M^2));
SIGMA = sqrt(log(V/M^2 + 1));

% Create n gauss distributed ICs
for i = 1:ICdefault;        
        gaussIC(ICdefault ~=0) = lognrnd(MU,SIGMA,M,N);
        rndmic = gaussIC{i};
        resultsmex{i}=model_toettcher2008mex(0:120, rndmic);
end


%Update the IQM-model with new IC values
toettcher2008_ICupdate = IQMinitialconditions(toettcher2008,rndmic);

%Simulate and generate data w/ new IC values (Random)
toettcher2008_sim_update = IQMsimulate(toettcher2008_ICupdate,120);


%Update the MEX-model with new IC values

%Simulate and generate data w/ new IC values (Random)
results_mex_update = model_toettcher2008mex(toettcher2008sim.time, rndmic, Pdefault);
end
