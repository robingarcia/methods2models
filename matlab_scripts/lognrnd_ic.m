%% Function for random IC
function [rndmic,t_iqm] = lognrnd_ic

% Load model
toettcher2008 = IQMmodel('model_toettcher2008.txt');
%toettcher2008_sim = model_toettcher2008iqm(120);
% Simulate IQM model and generate data with default IC values
toettcher2008sim = IQMsimulate(toettcher2008,120); %simulation time = 120
t_iqm = toettcher2008sim.time;
% Fetch the IC vector
ICdefault = IQMinitialconditions(toettcher2008); %IC-vector w/ default IC

%Fetch the parameter vector
[parameters,values]=IQMparameters(toettcher2008); %Parameter-vector w/ deafault parameters
Pdefault = values; 

% Simulate MEX model and generate data with default values
%results_mex = model_toettcher2008mex(t_iqm,ICdefault, Pdefault); %simulation time = t_iqm = 120


% Change the IC value log normally distributed
IC_not_zero = ICdefault(ICdefault ~=0); %31-27
sigma = 1;
M = ICdefault;
V = sigma .* ICdefault;
%MU = zeros(1,31);
%SIGMA = zeros(1,31);
MU = log(M.^2 ./ sqrt(V+M.^2));
SIGMA = sqrt(log(V./M.^2 + 1));
%MUU = MUU(IC_not_zero);
%SIGMAA = SIGMAA(IC_not_zero);
%[M,V] = lognstat(MU,SIGMA);
% Create n gauss distributed ICs
L = length(ICdefault);
%gaussIC = zeros(1,31);
%gaussIC = zeros(1,31);
%IC_not_zero = ICdefault(ICdefault ~=0);

        for i = 1:L %ICdefault = 0; 
            %gaussIC = zeros(1,31)
            %gaussIC = ICdefault
            IC_not_zero = lognrnd(MU,SIGMA);
            %my_gaussIC{i} = random_ics;
            rndmic{i} = IC_not_zero;
        end

end
