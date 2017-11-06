function [Y,NewPathDensity,newScale] = M2M_analysis_temp(y_data,path,options)

%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%   FUNCTION WITHOUT WANDERLUST!
% %% Extract your variables
options.PathIndex   = 1:size(y_data,1);
%% FACS2Path Density
options.path_weights    = ones(1,length(options.PathIndex))*1;
options.path_bandwidths = ones(1,length(options.PathIndex))*(0.02)^0.5;
PathDensity = sbistFACS2PathDensity(y_data',path,options); %error because zero column?? (Check dimension of y_data)

%% FACS Density Trafo
gamma = options.gamma; %log(2)/mean(t_period(1,:));% growthrate
newScale.pdf = @(a) 2*gamma*exp(-gamma.*a);
newScale.cdf = @(a) 2-2*exp(-gamma.*a);
newScale.coDomain = [0,log(2)/gamma];
NewPathDensity = sbistFACSDensityTrafo(PathDensity,newScale);%Wanderlust
options.doplots = 0; %0 = no plot , 1 = plot
PlotERAVariance(y_data,NewPathDensity,options);
% M2M_statisticP(NewPathDensity);
M2M_transformationP(NewPathDensity,newScale)
%% Output
% s_Exp=NewPathDensity.s_single_cell_Expectation;
a_Exp=NewPathDensity.a_single_cell_Expectation;
% s_Var=NewPathDensity.s_single_cell_Variance;
a_Var=NewPathDensity.a_single_cell_Variance;
% s_Exp=[s_Exp{:}];
a_Exp=[a_Exp{:}];

%% Calculate function
Y=M2M_function_temp(a_Exp,a_Var);
end

