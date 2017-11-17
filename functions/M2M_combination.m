function [B,New,Scale] = M2M_combination(errordata,t_period,statenames,y_0,combi)
%This function calculates the area for a particular measurement output
%(e.g. [7,11]
% It is a standalone function. 
%
% [INPUT]
% errordata       Your dataset
% t_period        Average cell cylce period of all cells
% statenames      Your statenames
% y_0             Your initial conditions
% combi           Your measurement output
%
% [OUTPUT]
% B               Integral of variance over the age (The smaller the better)
% New             Stored functions
% Scale           Your pdf and cdf
% 
% [EXAMPLE]
% [B,new,scale]=M2M_combination(errordata,t_period,statenames,y_0,[1,2])

tic
load_options
    options.Ynames		= statenames(combi);
    options.gamma		= log(2)/mean(t_period(1,:));
    options.PathIndex   = 1:size(combi,2);
    %Wanderlust
    [G,y_data,~,~] = PathfromWanderlust(errordata(combi,:)',options,y_0(combi));
    path=G.y;
    %Function
    [Y,New,Scale]=M2M_analysis_temp(y_data',path,options);%New functions (update)
    x = linspace(0,1,size(Y,2));%Normalized because from 0 to 1
    B=trapz(x,Y);
    toc
end

