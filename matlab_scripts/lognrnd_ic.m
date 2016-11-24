%% Function for random IC
function [toettcher2008_sim_update] = lognrnd_ic

% Load model
toettcher2008 = IQMmodel('model_toettcher2008.txt');

% Simulate IQM model and generate data with default IC values
toettcher2008_sim = IQMsimulate(toettcher2008,120); %simulation time = 120

% Fetch the IC vector
IC_default = IQMinitialconditions(toettcher2008); %IC-vector w/ default IC

%Fetch the parameter vector
[parameters,values]=IQMparameters(toettcher2008); %Parameter-vector w/ deafault parameters
P_default = values; 

% Simulate MEX model and generate data with default values
toettcher2008_simex = model_toettcher2008MEX(0:120); %simulation time = 120
results_mex = model_toettcher2008mex(toettcher2008_sim.time, IC_default, P_default);

% Change the IC value log normally distributed
sigma = 1;
M = IC_default;
V = sigma * IC_default;
MU = log(M^2 / sqrt(V+M^2));
SIGMA = sqrt(log(V/M^2 + 1));

% Create n random ICs
for i = 1:n
    gauss_IC = zero(1,31);
    gauss_IC{i} = lognrnd(MU,SIGMA,M,N)
end


%Update the IQM-model with new IC values
toettcher2008_ICupdate = IQMinitialconditions(toettcher2008,IC_rndm);

%Simulate and generate data w/ new IC values (Random)
toettcher2008_sim_update = IQMsimulate(toettcher2008_ICupdate,120);


%Update the MEX-model with new IC values

%Simulate and generate data w/ new IC values (Random)
end
