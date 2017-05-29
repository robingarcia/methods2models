%function [results,Summary] = run_all
profile on
addpath(genpath('~/methods2models'));
load('toettcher_statenames.mat');

%% 1) User inputs --------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[~,tF,lb,N,ic]=userinteraction;

%% 2) Original statevalues -----------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--> Preallocation area <--
simdata = cell(1,N);
random_statevalues = cell(1,N);
m = N; %size(samples,2);         
rndm_measurement = cell(1,N);
measurement = cell(1,N);
mydata = zeros(32,2*N);
%TSPAN = zeros(N,m+2);    

%for i = 1:N
original_data = model_toettcher2008mex(tF,ic);
original_statevalues = original_data.statevalues';
[~,locs_apc] = findpeaks(original_statevalues(6,:));
y_0 = original_statevalues(:,locs_apc(end));
y_0(end+1)=2; % DNA = 2N at Cellcycle start
% --> No loop detected!
%% 3) Randomize IC -------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:N
rndmic = M2Mlognrnd_ic(ic); % Generate gaussian distributed ICs
%--> Loop detected! (Results stored in a CELL!)
%% 4) Data generation-----------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-----> Preallocation <--------%
%simdata = cell(1,N);           %
%random_statevalues = cell(1,N);%
%------------------------------%
%for i = 1:N
  simdata = model_toettcher2008mex(tF,rndmic); %C-Model (MEX-File)
  random_statevalues = simdata.statevalues; %Extract the statevalues
%end
%Loop detected! (Results stored in a CELL!)
%% 5) Measurement---------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
snap=2;
[start, samples,t_period] = M2Mtimepoints(random_statevalues, tF, lb,N,snap);
% Attention: Use N as input for timepoints!!!
% --> Many loops detected within timepoints!
%% 6) Simulate the model--------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--> Preallocation <---------%
%m = size(samples,2);         %
%rndm_measurement = cell(1,N);%
%measurement = cell(1,N);     %
%TSPAN = zeros(N,m+2);        %
%----------------------------%
%for i = 1:N 
    tspan = horzcat(0,sort(samples,2),t_period(1,i)); % time vector from 0 to 30 (set t0 = 0)
    %TSPAN(i,:) = tspan;
    simulationIC = start; %APC peak = start = IC = t0 (with (1,:) only one period is used here)
%--------------------------------------------------------------------------
% NEW SIMULATION (SNAPSHOTS)
rndm_measurement= model_toettcher2008MEX(tspan,simulationIC);
measurement = rndm_measurement.statevalues;
%--------------------DNA Simulation----------------------------------------
y_DNA = M2MDNAsim(tspan,t_period(1,i),t_period(2,i), t_period(3,i))';
%--------------------------------------------------------------------------
measurement = horzcat(measurement,y_DNA)'; %Save statevalues only
measurement = measurement(:,2:end-1);
mydata=[measurement]; %ERROR !!!
%end
%mydata = cell2mat(measurement);

%% 7) Error model (add noise to dataset) ---------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is necessary to gain realistic results
sig = 0.05;% Define your sigma (e.g 0.2)
errordata = error_model(mydata,sig);

end
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


%% 8) Measurement (Calculate C-Matrix) -----------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load_options
x = 1:size(ic,1)+1;%32; Include DNA as 32th
results=cell(1,size(ic,1));%Preallocation
Summary=cell(1,size(ic,1));%Preallocation
combinations = cell(1,size(nchoosek(x,size(ic,1)),1));%Preallocation
combination = cell(1,size(nchoosek(x,size(ic,1)),1)); %Combination names
comb = cell(size(nchoosek(x,size(ic,1)),1)-1,1);
Variance_S = cell(size(nchoosek(x,size(ic,1)),1)-1,1);
Variance_A = cell(size(nchoosek(x,size(ic,1)),1)-1,1);

zero_value = find(not(errordata(:,1)));
for j = 1%:size(ic,1) %j = Number of columns = Number of outputs
for i=1%:size(nchoosek(x,j),1)-1 %-1 to exclude DNA-DNA combination
[~,options.PathIndex,cmatrix] = Cmatrix(i,j,size(errordata,1),errordata);
ismem = ismember(zero_value,options.PathIndex);%Check if number iscontained
if ismem == 0 %No zero columns/rows contained
cmatrix = cmatrix';

%% 9) Wanderlust ---------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data = errordata';
% 9.1) PathfromWanderlust -------------------------------------------------
[G,y_data,~] = PathfromWanderlust(data,options,y_0,cmatrix);
path = G.y; % Check these values first !!!
% 9.2) FACS2Pathdensity ---------------------------------------------------
%options.path_weights = ones(size(y_data,2),1)*10;
options.path_weights = ones(1,length(options.PathIndex))*10;
PathDensity = sbistFACS2PathDensity(y_data,path,options);
% 9.3) FACSDensityTrafo ---------------------------------------------------
gamma = log(2)/mean(t_period(1,:));% growthrate 18 = average cell cycle duration
newScale.pdf = @(a) 2*gamma*exp(-gamma.*a);
newScale.cdf = @(a) 2-2*exp(-gamma.*a);
newScale.coDomain = [0,log(2)/gamma];
NewPathDensity = sbistFACSDensityTrafo(PathDensity,newScale);
options.doplots = 1; %0 = no plot , 1 = plot
PlotERAVariance(data,NewPathDensity,options);
else
    
end
combinations{i} = NewPathDensity;
combination{i,1} = options.PathIndex;
comb{i,1} = strjoin(options.Ynames(combination{i}));
Variance_S{i,1} = mean(combinations{:,i}.s_single_cell_Variance);
Variance_A{i,1} = mean(combinations{:,i}.a_single_cell_Variance);
end
summary =([]);
summary.comb = comb;
summary.Variance_S = Variance_S;
summary.Variance_A = Variance_A;
%struct2table(summary)

Summary{j} = summary;
struct2table(Summary{j})
results{j} = combinations;
end
%% Save workspace
% cd('~/methods2models/datasets/output/');
% save([filename '.mat'],'results', '-v7.3');
% cd('~/methods2models/')
%end

