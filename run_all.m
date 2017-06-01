%function [errordata] = run_all
profile on
addpath(genpath('~/methods2models'));
load('toettcher_statenames.mat');

%% 1) User inputs --------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[~,tF,lb,N,ic,snaps,sig]=userinteraction;

%% 2) Original statevalues -----------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%original_data = model_toettcher2008MEX(tF,ic);
tic
original_data = model_toettcher2008mex(tF,ic);
original_statevalues = original_data.statevalues';
[~,locs_apc] = findpeaks(original_statevalues(6,:));
y_0 = original_statevalues(:,locs_apc(end));
y_0(end+1)=2; % DNA = 2N at Cellcycle start
% --> No loop detected!
toc
%% 3) Randomize IC -------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
rndmic = lognrnd_ic(N,ic); % Generate gaussian distributed ICs
toc
%--> Loop detected! (Results stored in a CELL!)
%% 4) Data generation-----------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-----> Preallocation <--------%
simdata = cell(1,N);           %
random_statevalues = cell(1,N);%
%------------------------------%
tic
for i = 1:N
  simdata{i} = model_toettcher2008mex(tF,rndmic(:,i)); %C-Model (MEX-File)
  random_statevalues{i} = simdata{1,i}.statevalues;%Extract the statevalues
end
toc
%Loop detected! (Results stored in a CELL!)
%% 5) Measurement---------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
[start, samples,t_period] = timepoints_template(random_statevalues,lb,N,snaps);
toc
% Attention: Use N as input for timepoints!!!
% --> Many loops detected within timepoints!
%% 6) Simulate the model--------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--> Preallocation <---------%
%m = size(samples,2);         %
rndm_measurement = cell(1,N);%
measurement = cell(1,N);     %
%TSPAN = zeros(N,m+2);        %
%----------------------------%
tic
for i = 1:N 
    tspan = horzcat(0,sort(samples(i,:),2),t_period(1,i)); % time vector from 0 to 30 (set t0 = 0)
    %TSPAN(i,:) = tspan;
    simulationIC = start(i,:); %APC peak = start = IC = t0 (with (1,:) only one period is used here)
%--------------------------------------------------------------------------
% NEW SIMULATION (SNAPSHOTS)
rndm_measurement{i} = model_toettcher2008mex(tspan,simulationIC);
measurement{i} = rndm_measurement{1,i}.statevalues;
%--------------------DNA Simulation----------------------------------------
y_DNA = DNAcontent(tspan,t_period(1,i),t_period(2,i), t_period(3,i))';
%--------------------------------------------------------------------------
measurement{i} = horzcat(measurement{i},y_DNA)'; %Save statevalues only
measurement{i} = measurement{i}(:,2:end-1);
end
toc
mydata = cell2mat(measurement);

%% 7) Error model (add noise to dataset) ---------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is necessary to gain realistic results
tic
errordata = error_model(mydata,sig);
toc

%% 8) Measurement (Calculate C-Matrix) -----------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load_options
x = 1:size(ic,1)+1;%32; Include DNA as 32th
results=cell(1,size(ic,1));%Preallocation
Summary=cell(1,size(ic,1));%Preallocation
combinations = cell(1,size(VChooseK(x,size(ic,1)),1));%Preallocation
combination = cell(size(VChooseK(x,size(ic,1)),1),1); %Combination names
comb = cell(size(VChooseK(x,size(ic,1)),1)-1,1);
all_comb = cell(1,size(ic,1));
Variance_S = zeros(size(VChooseK(x,size(ic,1)),1)-1,N*snaps); %cell(size(VChooseK(x,size(ic,1)),1)-1,1);
Variance_A = zeros(size(VChooseK(x,size(ic,1)),1)-1,N*snaps);%cell(size(VChooseK(x,size(ic,1)),1)-1,1);
s_E = zeros(size(VChooseK(x,size(ic,1)),1)-1,N*snaps);
a_E = zeros(size(VChooseK(x,size(ic,1)),1)-1,N*snaps);
%NPD = zeros(size(VChooseK(x,size(ic,1)),1)-1,1);
area_S = zeros(size(VChooseK(x,size(ic,1)),1)-1,1);
area_A = zeros(size(VChooseK(x,size(ic,1)),1)-1,1);
zero_value = find(not(errordata(:,1)));
tic
for j = 1%:size(ic,1) %j = Number of columns = Number of outputs
    tic
for i=1:4%size(VChooseK(x,j),1)-1 %-1 to exclude DNA-DNA combination
    tic
[~,options.PathIndex,cmatrix] = Cmatrix(i,j,size(errordata,1),errordata);
ismem = ismember(zero_value,options.PathIndex);%Check if number iscontained
if ismem == 0 %No zero columns/rows contained
cmatrix = cmatrix';

%% 9) Wanderlust ---------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data = errordata';
%% 9.1) PathfromWanderlust -------------------------------------------------
[G,y_data,~] = PathfromWanderlust(data,options,y_0,cmatrix);
path = G.y; % Check these values first !!!
%% 9.2) FACS2Pathdensity ---------------------------------------------------
%options.path_weights = ones(size(y_data,2),1)*10;
options.path_weights = ones(1,length(options.PathIndex))*10;
PathDensity = sbistFACS2PathDensity(y_data,path,options);
%% 9.3) FACSDensityTrafo ---------------------------------------------------
gamma = log(2)/mean(t_period(1,:));% growthrate
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
all_comb{1,j} = combination;
comb{i,1} = strjoin(options.Ynames(combination{i}));
[s_E(i,:),z]=sort(cell2mat(NewPathDensity.s_single_cell_Expectation),2);
Variance_S(i,:) = NewPathDensity.s_single_cell_Variance(z);
area_S(i) = trapz(s_E(i,:),Variance_S(i,:));

[a_E(i,:),z]=sort(cell2mat(NewPathDensity.a_single_cell_Expectation),2);
Variance_A(i,:) = NewPathDensity.a_single_cell_Variance(z);
area_A(i)= trapz(a_E(i,:), Variance_A(i,:));
end

summary =([]);
%summary.comb = comb;
summary.s_E = s_E;
summary.a_E = a_E;
summary.Variance_S = Variance_S;
summary.Variance_A = Variance_A;
summary.area_S = area_S;
summary.area_A = area_A;
summary.comb = combination;
%struct2table(summary)

Summary{j} = summary;
%struct2table(Summary{j});
results{j} = combinations;

% %c(:,j) = categorical({summary.comb{i,j}});
% var_a = summary.Variance_A;
% min_a = min(var_a);
% names = comb{var_a == min(var_a)};
% recomm = ['We recommend: ',names, '.', 'Its variance is: ',num2str(min_a)];
% disp(recomm)
%Barplot 
%bar(options.PathIndex(1),min_a); %Plot the mininal Variance as barplot
combi=cell2mat(summary.comb);
c = categorical(combi);
%bar(summary.area_A)

%bar(all_comb{1,j}{i,:},summary.area_A(i))
%bar(combi(i,:),summary.area_A(i))
bar(Summary{1,j}.area_A)
end
toc
%% Save workspace
% cd('~/methods2models/datasets/output/');
% save([filename '.mat'],'results', '-v7.3');
% cd('~/methods2models/')
%end

