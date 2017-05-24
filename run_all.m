function [results,Summary] = run_all
profile on
addpath(genpath('~/methods2models'));
load('toettcher_statenames.mat');

%% 1) User inputs --------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[~,tF,lb,N,ic]=userinteraction;

%% 2) Original statevalues -----------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%original_data = model_toettcher2008MEX(tF,ic);
original_data = model_toettcher2008mex(tF,ic);
original_statevalues = original_data.statevalues';
[~,locs_apc] = findpeaks(original_statevalues(6,:));
y_0 = original_statevalues(:,locs_apc(end));
y_0(end+1)=2; % DNA = 2N at Cellcycle start

%% 3) Randomize IC -------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rndmic = lognrnd_ic(N,ic); % Generate gaussian distributed ICs

%% 4) Data generation-----------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-----> Preallocation <--------%
simdata = cell(1,N);           %
random_statevalues = cell(1,N);%
%------------------------------%
for i = 1:N
  simdata{i} = model_toettcher2008mex(tF,rndmic{i}); %C-Model (MEX-File)
  random_statevalues{i} = simdata{1,i}.statevalues;%Extract the statevalues
end

%% 5) Measurement---------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[start, samples,t_period] = timepoints_template(random_statevalues, tF, lb);

%% 6) Simulate the model--------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--> Preallocation <---------%
m = size(samples,2);         %
rndm_measurement = cell(1,N);%
measurement = cell(1,N);     %
TSPAN = zeros(N,m+2);        %
%----------------------------%
for i = 1:N 
    tspan = horzcat(0,sort(samples(i,:),2),t_period(1,i)); % time vector from 0 to 30 (set t0 = 0)
    TSPAN(i,:) = tspan;
    simulationIC = start{2,i}; %APC peak = start = IC = t0 (with (1,:) only one period is used here)
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

%% 7) Error model (add noise to dataset) ---------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is necessary to gain realistic results
sig = 0.05;% Define your sigma (e.g 0.2)
errordata = error_model(mydata,sig);

%% 8) Measurement (Calculate C-Matrix) -----------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
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
tic
for i=1%:size(nchoosek(x,j),1)-1 %-1 to exclude DNA-DNA combination
[~,options.PathIndex,cmatrix] = Cmatrix(i,j,size(errordata,1),errordata);
ismem = ismember(zero_value,options.PathIndex);%Check if number iscontained
if ismem == 0 %No zero columns/rows contained
cmatrix = cmatrix';



%% 9) Wanderlust ---------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data = errordata';
% 9.1) PathfromWanderlust -------------------------------------------------
tic
[G,y_data,~] = PathfromWanderlust(data,options,y_0,cmatrix);
path = G.y; % Check these values first !!!
toc
% 9.2) FACS2Pathdensity ---------------------------------------------------
%options.path_weights = ones(size(y_data,2),1)*10;
options.path_weights = ones(1,length(options.PathIndex))*10;
PathDensity = sbistFACS2PathDensity(y_data,path,options);
% 9.3) FACSDensityTrafo ---------------------------------------------------
gamma = log(2)/mean(t_period(1,:));%18;  % growthrate 18 = average cell cycle duration
newScale.pdf = @(a) 2*gamma*exp(-gamma.*a);
newScale.cdf = @(a) 2-2*exp(-gamma.*a);
newScale.coDomain = [0,log(2)/gamma];
NewPathDensity = sbistFACSDensityTrafo(PathDensity,newScale);
options.doplots = 0; %0 = no plot , 1 = plot
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
toc
toc
%% Save workspace
% cd('~/methods2models/datasets/output/');
% save([filename '.mat'],'results', '-v7.3');
% cd('~/methods2models/')
end

