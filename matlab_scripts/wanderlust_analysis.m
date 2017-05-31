function [] = wanderlust_analysis(errordata,ic,y_0,t_period)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
load('toettcher_statenames.mat');
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
for i=1:5%size(nchoosek(x,j),1)-1 %-1 to exclude DNA-DNA combination
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
options.doplots = 0; %0 = no plot , 1 = plot
PlotERAVariance(data,NewPathDensity,options);
else
    
end
combinations{i} = NewPathDensity;
combination{i,1} = options.PathIndex;
comb{i,1} = strjoin(options.Ynames(combination{i}));
Variance_S{i,1} = trapz(combinations{:,i}.s_single_cell_Variance);
Variance_A{i,1} = trapz(combinations{:,i}.a_single_cell_Variance);
end
summary =([]);
summary.comb = comb;
summary.Variance_S = Variance_S;
summary.Variance_A = Variance_A;
%struct2table(summary)

Summary{j} = summary;
struct2table(Summary{j});
results{j} = combinations;


var_a = cell2mat(Variance_A);
min_a = min(var_a);
names = comb{var_a == min(var_a)};
recomm = ['We recommend: ',names, '.', 'Its variance is: ',num2str(min_a)];
disp(recomm)
end
end

