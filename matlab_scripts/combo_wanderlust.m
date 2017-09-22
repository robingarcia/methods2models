function [combo] = combo_wanderlust(errordata,t_period,y_0,statenames)
%UNTITLED Summary of this function goes here
%   Calculate datapoints for new combination
options.Ynames = statenames;
load_options; %import t_period
data = errordata';
%% Wanderlust
[G,w_data,~,~] = PathfromWanderlust(data,options,y_0);%Normalized data used here!
w_path = G.y;
%% FACS2PathDensity
y_data = w_data;
path = w_path;
options.path_weights    = ones(1,length(y_0))*1;%10;%20;
options.path_bandwidths = ones(1,length(y_0))*(0.02)^0.5;%10;%20;
PathDensity = sbistFACS2PathDensity(y_data,path,options);
% PathDensity = sbistFACS2PathDensity(data,path,options);
%% FACSDensityTrafo
gamma = log(2)/mean(t_period(1,:));% growthrate
newScale.pdf = @(a) 2*gamma*exp(-gamma.*a);
newScale.cdf = @(a) 2-2*exp(-gamma.*a);
newScale.coDomain = [0,log(2)/gamma];
NewPathDensity = sbistFACSDensityTrafo(PathDensity,newScale);

%% Data extraction and preparation
s_E (1,:)=  cell2mat(NewPathDensity.s_single_cell_Expectation);
a_E(1,:) = cell2mat(NewPathDensity.a_single_cell_Expectation);
Variance_S(1,:) = NewPathDensity.s_single_cell_Variance;
Variance_A(1,:) = NewPathDensity.a_single_cell_Variance;

combo = ([]);
combo.s_E = s_E;
combo.a_E = a_E;
combo.Variance_S = Variance_S;
combo.Variance_A = Variance_A;
end

