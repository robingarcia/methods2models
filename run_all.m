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
y_0(end+1)=2.2; % DNA = 2N at Cellcycle start 
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
sig = 0.05;%0.02; % Define your sigma (0.2)
errordata = error_model(mydata,sig);
%Cmatrix = cell(m,n);
for i=1:32
figure
scatter(mydata(32,:),mydata(i,:), 'ob');
hold on
scatter(errordata(32,:),errordata(i,:),'or')
end
%% Calculate C-Matrix -----------------------------------------------------

for j = 1%:size(ic,1) %j = Number of columns = Number of outputs
x = 1:size(ic,1)+1;%32; Include DNA as 32th
%cmatrix = Cmatrix(j,size(errordata,1));
%C = zeros(size(cmatrix,2), size(errordata,1));
for i = 14%:size(nchoosek(x,j),1)
%   C(1,cmatrix(i,1))=1;
%   C(end,cmatrix(i,2))=1;
%   Y = C*errordata;
%[Y,options.PathIndex,cmatrix] = Cmatrix(i,j,size(errordata,1),errordata); 
[Y,options.PathIndex,cmatrix] = Cmatrix(i,j,size(mydata,1),mydata); 


%% Wanderlust -------------------------------------------------------------
%data = Y';
data = errordata;
load_options
%start = [-3,-1.2];
%startballsize = [0.02,0.02];
%--options.wanderlust.wanderlust_weights = ones(1,length(options.PathIndex));
doplots = 1;
num_graphs = 30;
%options.PathIndex = [1,2]; %User interaction with options
manual_path = 0;
% 1) PathfromWanderlust ---------------------------------------------------
tic
[G,y_data,inball] = PathfromWanderlust(data,options,y_0,cmatrix);
path = G.y; % Check these values first !!!
toc
% =========================================================================
%% Plot data and path
% k=i+j;
% rect = [20 20 800 600];
% figure('Color','w','Position',rect)
% fh = subplot(1,2,1);
% 
% 	%fh= figure('Color','w','Position',rect);
% 	psc = scatter(fh,y_data(:,1),y_data(:,2),'ob');
% 	title(fh,'Autoselect')
% 	xlabel(options.Ynames(options.PathIndex(1)))
% 	ylabel(options.Ynames(options.PathIndex(2)))
% 	hold on
%     psc = scatter(fh,y_data(inball,1),y_data(inball,2),'or');
    
%figpath = subplot(1,2,2);    
figure('Color','w','Position',[50,50,800,600])
plotDataAndPath(data(:,options.PathIndex),path,options);
%==========================================================================
% % 2) FACS2Pathdensity -----------------------------------------------------
% tic
% PathDensity = sbistFACS2PathDensity(data,path,options,cmatrix);
% toc
% % 3) FACSDensityTrafo -----------------------------------------------------
% tic
% gamma = log(2)/mean(t_period(1,:));%18;  % growthrate 18 = average cell cycle duration
% newScale.pdf = @(a) 2*gamma*exp(-gamma.*a);
% newScale.cdf = @(a) 2-2*exp(-gamma.*a);
% newScale.coDomain = [0,log(2)/gamma];
% 
% NewPathDensity = sbistFACSDensityTrafo(PathDensity,newScale);
% toc
% tic
% options.doplots = 1; %0 = no plot , 1 = plot
% PlotERAVariance(data,NewPathDensity,options);
% toc
end
end
%% Save workspace
cd('~/methods2models/datasets/output/');
save([filename '.mat'],'mydata','errordata','Y', '-v7.3');
cd('~/methods2models/')
%end

