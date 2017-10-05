function [s_Exp,a_Exp,s_Var,a_Var] = M2M_analysis_temp(data,t_period,y_0,options)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% %% Extract your variables
% data=input.errordata';
% t_period=input.t_period;
% y_0=input.y_0;
% statenames=input.statenames;

% load_options        % Load options for Wanderlust
% options.Ynames		= statenames;
% options.gamma		= log(2)/mean(t_period(1,:));%Is this ok?
% options.PathIndex   = 1:size(data,2);
%% Path from Wanderlust
[G,y_data,~,~] = PathfromWanderlust(data,options,y_0);
path = G.y;
% y_data=y_data';

%% FACS2Path Density
options.path_weights    = ones(1,length(options.PathIndex))*1;
options.path_bandwidths = ones(1,length(options.PathIndex))*(0.02)^0.5;
PathDensity = sbistFACS2PathDensity(y_data,path,options); %error because zero column??

%% FACS Density Trafo
gamma = log(2)/mean(t_period(1,:));% growthrate
newScale.pdf = @(a) 2*gamma*exp(-gamma.*a);
newScale.cdf = @(a) 2-2*exp(-gamma.*a);
newScale.coDomain = [0,log(2)/gamma];
NewPathDensity = sbistFACSDensityTrafo(PathDensity,newScale);%Wanderlust
options.doplots = 0; %0 = no plot , 1 = plot
PlotERAVariance(data,NewPathDensity,options);

%% Output
s_Exp=NewPathDensity.s_single_cell_Expectation;
a_Exp=NewPathDensity.a_single_cell_Expectation;
s_Var=NewPathDensity.s_single_cell_Variance;
a_Var=NewPathDensity.a_single_cell_Variance;
s_Exp=[s_Exp{:}];
a_Exp=[a_Exp{:}];
end

