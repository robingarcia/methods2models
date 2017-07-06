function [w_data,w_path] = M2M_pre_wanderlust(errordata,y_0,statenames,t_period)
% This function applies Wanderlust to all states of your model 
% 
% 
% [Syntax]
% [w_data,w_path] = pre_wanderlust(errordata,y_0,statenames,t_period)
% 
% [INPUT]
% errordata:          number: Your simulated data
% y_0:                number: Concentration of species at t=0
% statenames:         cell: Names of the species
% t_period:           number: Cell cycle period of every cell
% 
% [OUTPUT]
% w_data:         number:?
% w_path:         number:Calculated trajectory
% [EXAMPLE]
% Pending
load_options
options.Ynames		= statenames;
options.gamma		= log(2)/mean(t_period(1,:));
%% Calculate Wanderlust for all states ------------------------------------
disp('Calculate Wanderlust for all states -------------------------------')
data = errordata';
[G,w_data,~,~] = PathfromWanderlust(data,options,y_0);
w_path = G.y; % Check these values first !!!
end

