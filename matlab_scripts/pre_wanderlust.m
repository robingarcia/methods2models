function [w_path] = pre_wanderlust(errordata,y_0,statenames,t_period)
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
load_options        % Load options for Wanderlust
options.Ynames		= statenames;
options.gamma		= log(2)/mean(t_period(1,:));%Is this ok?
options.doplots     = 0;
options.PathIndex   = 1:size(errordata,1);
%% Calculate Wanderlust for all states ------------------------------------
disp('Calculate Wanderlust for all states -------------------------------')
data = errordata';
[G,~,~,~] = PathfromWanderlust(data,options,y_0);

% w_data = errordata;

w_path = G.y; % Check these values first !!!
end

