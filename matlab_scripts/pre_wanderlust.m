function [w_data,w_path] = pre_wanderlust(errordata,ic,y_0,statenames,t_period)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
load_options
options.Ynames		= statenames;
%% Calculate Wanderlust for all states ------------------------------------
disp('Calculate Wanderlust for all states -------------------------------')
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
end

