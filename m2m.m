function [results] = m2m()
% This function calculates the best measurement combination 
% 
% 
% [Syntax]
% [results] = m2m
% 
% [INPUT]
% See:                userinput
% 
% [OUTPUT]
% results:            struct: Results
%
% [EXAMPLE]
% Pending
profile on
addpath(genpath('~/methods2models'));
statenames = cell(1,32);
load('~/methods2models/datasets/toettcher_statenames.mat');


%% Datageneration ---------------------------------------------------------
[ic,data,errordata,y_0,t_period,N,snaps,time] = data_generation;


%% Purge datasets ---------------------------------------------------------
[errordata,~,nzero] = M2M_purge(errordata);
[ic, ~] = M2M_purge(ic);
[y_0, ~] = M2M_purge(y_0);
statenames = statenames(nzero);


%% Wanderlust analysis ----------------------------------------------------
[w_data,w_path] = pre_wanderlust(errordata,y_0,statenames,t_period);


%% Pre computation --------------------------------------------------------
for j = 1% 1, 2 and 27 measurement outputs
summary = M2M_combinatorics(w_data,w_path,t_period,ic,errordata,statenames,j);
end


%% Functions and new datapoints -------------------------------------------
[y,f] = M2M_functions(summary,ic,N,snaps);



%% 2 combinations ---------------------------------------------------------
[results_save] = M2M_twocombo(y,ic,N,snaps);
% x = normdata(linspace(0,1,N*snaps));
% results_save = ([]);
% z = 1:size(ic,1);% Number of parameters
% for i = 2 %Only 2 combinations are considered here
%     results_save.i = i;
%     C = WChooseK(z,i);
%     trap_area = zeros(1,size(C,1));
%     for j = 1:size(C,1)
%         y_1 = y(C(j,1),:);
%         y_2 = y(C(j,2),:);
%         y_previous = min(y_1,y_2);
%         trap_area(1,j) = trapz(x,y_previous);
%     end
% end
% [h,Track] = min(trap_area);
% best = C(Track,:);
% for j = Track
%     y_1 = y(C(j,1),:);
%     y_2 = y(C(j,2),:);
%     y_previous = min(y_1,y_2);
% end
% results_save.best = best;%Best combination 2 from 27
% results_save.h = h; %Area under curve
% results_save.y_previous = y_previous;


%% New approach -----------------------------------------------------------
[best_comb] = M2Marea(results_save,errordata,y,f,ic,y_0,t_period,statenames);
%% Plots ------------------------------------------------------------------


%% Save area --------------------------------------------------------------
results = ([]);
results.names = statenames;
results.ic = ic;
results.time = time;
results.N = N;
results.snaps = snaps;
results.data = data;
results.errordata = errordata;
results.y_0 = y_0;
results.t_period = t_period;
results.f = f;
results.best_comb = best_comb;
end