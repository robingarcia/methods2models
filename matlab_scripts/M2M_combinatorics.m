function [summary] = M2M_combinatorics(w_data,w_path,t_period,ic,errordata,statenames,j)
% This function calculates the variance and the expectation for every state
% 
% 
% [Syntax]
% [summary] = M2M_combinatorics(w_data,w_path, t_period,ic,errordata,statenames,j)
% 
% [INPUT]
% w_data:           number: Data from Wanderlust
% w_path:           number: Trajectory calculated by Wanderlust
% t_period:         number: Cell cycle period
% ic:               number: Initial conditions
% errordata:        number: Data with noise
% statenames:       cell:   Names of the species
% j:                number: Number of simultaneously measured outputs
% 
% [OUTPUT]
% summary:          struct: Stores the results of this function
% 
% [EXAMPLE]
% Pending
load_options
options.Ynames		= statenames;

% Determine the max size---------------------------------------------------
number = zeros(size(ic,1),1);
for i = 1:size(ic,1)
    number(i,1)=size(WChooseK(1:size(ic,1),i),1);
end
%% Preallocation area =====================================================
combination = cell(number(j,1),1); %Combination names
data = errordata';
Variance_S = zeros(1,size(errordata,2));
Variance_A = zeros(1,size(errordata,2));
s_E = zeros(1,size(errordata,2));
a_E = zeros(1,size(errordata,2));
    
for i=1:size(WChooseK(1:size(ic,1),j),1)%without DNA
[~,options.PathIndex,cmatrix] = Cmatrix(i,j,size(errordata,1),errordata);
y_data = cmatrix * w_data';
y_data = y_data';
path = cmatrix * w_path;
disp_var = ['Combination --->>:',num2str(options.PathIndex)];
%% 9) Wanderlust ---------------------------------------------------------%
disp(disp_var)


%% 9.2) FACS2Pathdensity ---------------------------------------------------
options.path_weights = ones(1,length(options.PathIndex))*100;%10;%20;
PathDensity = sbistFACS2PathDensity(y_data,path,options); %error because zero column??


%% 9.3) FACSDensityTrafo ---------------------------------------------------
gamma = log(2)/mean(t_period(1,:));% growthrate
newScale.pdf = @(a) 2*gamma*exp(-gamma.*a);
newScale.cdf = @(a) 2-2*exp(-gamma.*a);
newScale.coDomain = [0,log(2)/gamma];
NewPathDensity = sbistFACSDensityTrafo(PathDensity,newScale);
options.doplots = 0; %0 = no plot , 1 = plot
PlotERAVariance(data,NewPathDensity,options);

combination{i,1} = options.PathIndex;% Necessary?
s_E(i,:) = cell2mat(NewPathDensity.s_single_cell_Expectation);
a_E(i,:) = cell2mat(NewPathDensity.a_single_cell_Expectation);
Variance_S(i,:) = NewPathDensity.s_single_cell_Variance;
Variance_A(i,:) = NewPathDensity.a_single_cell_Variance;
end
summary =([]);
summary.new = NewPathDensity;
summary.s_Est = s_E;
summary.a_Est = a_E;
summary.Var_s = Variance_S;
summary.Var_a = Variance_A;
summary.comb = combination;

end

