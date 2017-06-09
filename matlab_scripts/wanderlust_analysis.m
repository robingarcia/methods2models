function [sum_results] = wanderlust_analysis(errordata,ic,y_0,t_period,statenames)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%load('toettcher_statenames.mat');
load_options
options.Ynames		= statenames;
%% 8) Measurement (Calculate C-Matrix) -----------------------------------%
disp('Measurement (Calculate C-Matrix) -----------------------------------')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%load_options
% Build all cells and arrays as big as possible
% Determine the max size---------------------------------------------------
number = zeros(size(ic,1),1);
for i = 1:size(ic,1)
    number(i,1)=size(WChooseK(1:size(ic,1),i),1);
end
max_combination = max(number); %We need this value to create our cells
%--------------------------------------------------------------------------

%% Preallocation area =====================================================
% x = 1:size(ic,1)+1;%32; Include DNA as 32th
Summary=cell(1,size(ic,1));%Preallocation


% combinations = cell(1,size(WChooseK(x,size(ic,1)),1));%Preallocation
% combination = cell(size(WChooseK(x,size(ic,1)),1),1); %Combination names
% comb = cell(size(WChooseK(x,size(ic,1)),1)-1,1);
% Variance_S = zeros(size(WChooseK(x,size(ic,1)),1)-1,N*snaps);%cell(size(VChooseK(x,size(ic,1)),1)-1,1);
% Variance_A = zeros(size(WChooseK(x,size(ic,1)),1)-1,N*snaps);%cell(size(VChooseK(x,size(ic,1)),1)-1,1);
% s_E = zeros(size(WChooseK(x,size(ic,1)),1)-1,N*snaps);
% a_E = zeros(size(WChooseK(x,size(ic,1)),1)-1,N*snaps);
% area_S = zeros(size(WChooseK(x,size(ic,1)),1)-1,1);
% area_A = zeros(size(WChooseK(x,size(ic,1)),1)-1,1);
combinations = cell(1,max_combination);%Preallocation
combination = cell(max_combination,1); %Combination names
comb = cell(max_combination-1,1);
% Variance_S = zeros(max_combination-1,N*snaps);%cell(size(VChooseK(x,size(ic,1)),1)-1,1);
% Variance_A = zeros(max_combination-1,N*snaps);%cell(size(VChooseK(x,size(ic,1)),1)-1,1);
% s_E = zeros(max_combination-1,N*snaps);
% a_E = zeros(max_combination-1,N*snaps);
% area_S = zeros(max_combination-1,1);
% area_A = zeros(max_combination-1,1);

%a_A = cell(1,size(ic,1));
%zero_value = find(not(errordata(:,1)));
%all_comb = cell(1,size(ic,1));

% MAYBE PREALLOCATION PROBLEM --> reason for low speed???
%==========================================================================
%==========================================================================
%% Calculate Wanderlust for all states ------------------------------------
tic
j = size(ic,1); %Measure all species simultaneously
i = size(WChooseK(1:size(ic,1),j),1);
[~,options.PathIndex,cmatrix] = Cmatrix(i,j,size(errordata,1),errordata);
cmatrix = cmatrix';
data = errordata';
[G,w_data,~,~] = PathfromWanderlust(data,options,y_0,cmatrix);
% G = wanderlust(y_data,params);
w_path = G.y; % Check these values first !!!
toc
%--------------------------------------------------------------------------
tic
for j = 1:size(ic,1) %j = Number of columns = Number of outputs
toc

% Preallocation for i-Loop-------------------------------------------------
% Variance_S = zeros(size(WChooseK(x,j),1)-1,1);
% Variance_A = zeros(size(WChooseK(x,j),1)-1,1);
% s_E = zeros(size(WChooseK(x,j),1)-1,1);
% a_E = zeros(size(WChooseK(x,j),1)-1,1);
% area_S = zeros(size(WChooseK(x,j),1)-1,1);
% area_A = zeros(size(WChooseK(x,j),1)-1,1);
%--------------------------------------------------------------------------
tic
for i=1:size(WChooseK(1:size(ic,1),j),1)%without DNA
    tic
[~,options.PathIndex,cmatrix] = Cmatrix(i,j,size(errordata,1),errordata);
%ismem = ismember(zero_value,options.PathIndex);%Check if number iscontained
%if ismem == 0 %No zero columns/rows contained
%cmatrix = cmatrix';
y_data = cmatrix * w_data';
y_data = y_data';
path = cmatrix * w_path;
%c_matrix{j,i}=cmatrix;
disp_var = ['Wanderlust --------:',num2str(options.PathIndex)];
%% 9) Wanderlust ---------------------------------------------------------%
disp(disp_var)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% data = errordata';
%% 9.1) PathfromWanderlust -------------------------------------------------

% [G,y_data,~] = PathfromWanderlust(data,options,y_0,cmatrix);
% path = G.y; % Check these values first !!!


%% 9.2) FACS2Pathdensity ---------------------------------------------------
%options.path_weights = ones(size(y_data,2),1)*10;
options.path_weights = ones(1,length(options.PathIndex))*10;
PathDensity = sbistFACS2PathDensity(y_data,path,options); %error because zero column??


%% 9.3) FACSDensityTrafo ---------------------------------------------------
gamma = log(2)/mean(t_period(1,:));% growthrate
newScale.pdf = @(a) 2*gamma*exp(-gamma.*a);
newScale.cdf = @(a) 2-2*exp(-gamma.*a);
newScale.coDomain = [0,log(2)/gamma];
NewPathDensity = sbistFACSDensityTrafo(PathDensity,newScale);
options.doplots = 0; %0 = no plot , 1 = plot
PlotERAVariance(data,NewPathDensity,options);
%else 
    
%end

combinations{i} = NewPathDensity;
combination{i,1} = options.PathIndex;
%all_comb{1,j} = combination;
comb{i,1} = strjoin(options.Ynames(combination{i}));
%==========================================================================
%==========================================================================
% [s_E(i,:),z]=sort(cell2mat(NewPathDensity.s_single_cell_Expectation),2);%!!!
% Variance_S(i,:) = NewPathDensity.s_single_cell_Variance(z);%!!!
% area_S(i) = trapz(s_E(i,:),Variance_S(i,:));
% 
% [a_E(i,:),z]=sort(cell2mat(NewPathDensity.a_single_cell_Expectation),2);%!!!
% Variance_A(i,:) = NewPathDensity.a_single_cell_Variance(z);%!!!
% area_A(i)= trapz(a_E(i,:), Variance_A(i,:));%!!!
%==========================================================================
%==========================================================================
end
toc
% area_A = bsxfun(@trapz,sort(cell2mat(summary.combinations{1,:}.a_single_cell_Expectation),2),summary.combinations{1,:}.a_single_cell_Variance(z));
% Create a struct for storage
summary =([]);
% summary.s_E = s_E;
% summary.a_E = a_E;
% summary.Variance_S = Variance_S;
% summary.Variance_A = Variance_A;
% summary.area_S = area_S;
% summary.area_A = area_A;
summary.comb = combination;
summary.combn = comb;
summary.combinations = combinations;

% Store every struct in its own cell
Summary{j} = summary;
%struct2table(Summary{j});


% %c(:,j) = categorical({summary.comb{i,j}});
% var_a = summary.Variance_A;
% min_a = min(var_a);
% names = comb{var_a == min(var_a)};
% recomm = ['We recommend: ',names, '.', 'Its variance is: ',num2str(min_a)];
% disp(recomm)
%Barplot 
%bar(options.PathIndex(1),min_a); %Plot the mininal Variance as barplot
%combi=cell2mat(summary.comb);

%bar(summary.area_A)

%bar(all_comb{1,j}{i,:},summary.area_A(i))
%bar(combi(i,:),summary.area_A(i))


end
toc
sum_results = cat(1,Summary{:});
%result_all = cat(1,sum_A(:).area_A); <-- I DID IT !!! \o/
%name_all = cat(1,sum_A(:).combn); < -- IT WORKS !!!
%result_combn = categorical(result_combn);
%barh(result_combn,result_areaA)
toc
end

