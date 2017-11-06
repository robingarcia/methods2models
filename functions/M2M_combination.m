function [B,New,Scale] = M2M_combination(errordata,t_period,statenames,y_0,options,combi)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

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
end

