%function [] = run_all
addpath(genpath('~/methods2models'));
load('toettcher_statenames.mat');
%% User inputs ------------------------------------------------------------
[filename,tF,lb,N,ic]=userinteraction;
%% -------------------Data generation--------------------------------------

rndmic = lognrnd_ic(N,ic); % Generate gaussian distributed ICs
simdata = cell(1,N);
random_statevalues = cell(1,N);
for i = 1:N
  simdata{i} = model_toettcher2008MEX(tF,rndmic{i}); %C-Model (MEX-File)
  random_statevalues{i} = simdata{1,i}.statevalues;%Extract the statevalues
end
%% Original statevalues ---------------------------------------------------
original_data = model_toettcher2008MEX(tF,ic);
original_statevalues = original_data.statevalues';
[pks_apc,locs_apc] = findpeaks(original_statevalues(6,:));
y_0 = original_statevalues(:,locs_apc(end));
y_0(end+1)=2; % DNA = 2N at Cellcycle start 
%% ---------------------Measurement----------------------------------------

[START, SAMPLES,t_period] = timepoints_template(random_statevalues, tF, lb);
%% ------------------Simulate the model------------------------------------

m = size(SAMPLES,2);
rndm_measurement = cell(1,N);
measurement = cell(1,N);
TSPAN = zeros(N,m+2);
%proport = zeros(n,1);
samples = SAMPLES;
for i = 1:N 
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
sig = 0.2; % Define your sigma
errordata = error_model(mydata,sig);
%Cmatrix = cell(m,n);


%% Calculate C-Matrix -----------------------------------------------------
j = 1; 
x = 1:32;
%cmatrix = Cmatrix(j,size(errordata,1));
%C = zeros(size(cmatrix,2), size(errordata,1));
for i = 4%:size(nchoosek(x,j),1)
%   C(1,cmatrix(i,1))=1;
%   C(end,cmatrix(i,2))=1;
%   Y = C*errordata;
Y = Cmatrix(i,j,size(errordata,1),errordata);   

%APCmax = 0.9950; %Define startpoint


%% Wanderlust -------------------------------------------------------------
data = Y';
load_options
start = [-3,-1.2];
startballsize = [0.02,0.02];
options.wanderlust.wanderlust_weights = [1,1];
doplots = 1;
num_graphs = 30;
PathIndex = [1,2]; %User interaction with options
manual_path = 0;
% 1) PathfromWanderlust
G = PathfromWanderlust(data,options,y_0([i end]));
path = G.y;
% 2) FACS2Pathdensity
PathDensity = sbistFACS2PathDensity(data,path,options);

% 3) FACSDensityTrafo 
gamma = log(2)/mean(t_period(1,:));%18;  % growthrate 18 = average cell cycle duration
newScale.pdf = @(a) 2*gamma*exp(-gamma.*a);
newScale.cdf = @(a) 2-2*exp(-gamma.*a);
newScale.coDomain = [0,log(2)/gamma];

NewPathDensity = sbistFACSDensityTrafo(PathDensity,newScale);

options.doplots = 1; %0 = no plot , 1 = plot
PlotERAVariance(data,NewPathDensity,options);
end
%% Save workspace
cd('~/methods2models/datasets/output/');
save([filename '.mat'],'mydata','errordata','Y', '-v7.3');
cd('~/methods2models/')
%end

