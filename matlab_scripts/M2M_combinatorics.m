function [summary] = M2M_combinatorics(w_data,w_path, t_period,ic,errordata,statenames,j)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
load_options
options.Ynames		= statenames;

% Determine the max size---------------------------------------------------
number = zeros(size(ic,1),1);
for i = 1:size(ic,1)
    number(i,1)=size(WChooseK(1:size(ic,1),i),1);
end
%max_combination = max(number); %We need this value to create our cells
%--------------------------------------------------------------------------
%% Preallocation area =====================================================
%x = 1:size(ic,1)+1;%32; Include DNA as 32th
% Summary=cell(1,size(ic,1));%Preallocation
%combinations = cell(1,max_combination);%Preallocation
combination = cell(number(j,1),1); %Combination names
%comb = cell(max_combination-1,1);
%==========================================================================
%==========================================================================
data = errordata';
% for j = 1:2%size(ic,1) %j = Number of columns = Number of outputs
% Preallocation for i-Loop-------------------------------------------------
Variance_S = zeros(1,size(errordata,2));%zeros(size(WChooseK(x,j),1)-1,1);
Variance_A = zeros(1,size(errordata,2));%zeros(size(WChooseK(x,j),1)-1,1);
s_E = zeros(1,size(errordata,2));%zeros(size(WChooseK(x,j),1)-1,1);
a_E = zeros(1,size(errordata,2));%zeros(size(WChooseK(x,j),1)-1,1);
%area_S = zeros(1,number(j,1));%zeros(size(WChooseK(x,j),1)-1,1);
%area_A = zeros(1,number(j,1));%zeros(size(WChooseK(x,j),1)-1,1);
%--------------------------------------------------------------------------
    
    
for i=1:size(WChooseK(1:size(ic,1),j),1)%without DNA
    tic
[~,options.PathIndex,cmatrix] = Cmatrix(i,j,size(errordata,1),errordata);
y_data = cmatrix * w_data';
y_data = y_data';
path = cmatrix * w_path;
disp_var = ['Wanderlust --------:',num2str(options.PathIndex)];
%% 9) Wanderlust ---------------------------------------------------------%
disp(disp_var)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% data = errordata';
%% 9.1) PathfromWanderlust -------------------------------------------------



%% 9.2) FACS2Pathdensity ---------------------------------------------------
options.path_weights = ones(1,length(options.PathIndex))*10;%20;
% options.path_weights = ones(1,size(wdata,2))*10;
PathDensity = sbistFACS2PathDensity(y_data,path,options); %error because zero column??


%% 9.3) FACSDensityTrafo ---------------------------------------------------
gamma = log(2)/mean(t_period(1,:));% growthrate
newScale.pdf = @(a) 2*gamma*exp(-gamma.*a);
newScale.cdf = @(a) 2-2*exp(-gamma.*a);
newScale.coDomain = [0,log(2)/gamma];
NewPathDensity = sbistFACSDensityTrafo(PathDensity,newScale);
options.doplots = 0; %0 = no plot , 1 = plot
PlotERAVariance(data,NewPathDensity,options);
%Var_E_plot(data,NewPathDensity,options);
%combinations{i} = NewPathDensity;
combination{i,1} = options.PathIndex;% Necessary?
s_E(i,:) = cell2mat(NewPathDensity.s_single_cell_Expectation);
a_E(i,:) = cell2mat(NewPathDensity.a_single_cell_Expectation);
Variance_S(i,:) = NewPathDensity.s_single_cell_Variance;
Variance_A(i,:) = NewPathDensity.a_single_cell_Variance;

%comb{i,1} = strjoin(options.Ynames(combination{i}));%Necessary?
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
toc
end
summary =([]);
summary.new = NewPathDensity;
summary.s_Est = s_E;
summary.a_Est = a_E;
summary.Var_s = Variance_S;
summary.Var_a = Variance_A;
%summary.area_S = area_S;
%summary.area_A = area_A;
summary.comb = combination;


% Store every struct in its own cell
% Summary{j} = summary;
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


% end
% sum_results = cat(1,Summary{:});

end

