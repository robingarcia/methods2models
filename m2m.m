function [results] = m2m(tF,lb,N,snaps,sig,mexmodelname)
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

% kk
% mexmodel = eval(sprintf('@%s',mexmodelname)) %!!!
input = ([]);
input.tF = tF;
input.lb = lb;
input.N = N;
input.snaps = snaps;
input.sig = sig;
input.mexmodelname = mexmodelname;
%% Datageneration ---------------------------------------------------------
[ic,data,errordata,y_0,t_period,N,snaps,time] = data_generation(tF,lb,N,snaps,sig);

%% Purge datasets ---------------------------------------------------------
[errordata,~,nzero] = M2M_purge(errordata);
[ic, ~] = M2M_purge(ic);
[y_0, ~] = M2M_purge(y_0);
statenames = statenames(nzero);

%% Wanderlust analysis ----------------------------------------------------
[w_data,w_path] = pre_wanderlust(errordata,y_0,statenames,t_period);


%% Pre computation --------------------------------------------------------
for j = 1% 1 measurement output
summary = M2M_combinatorics(w_data,w_path,t_period,ic,errordata,statenames,j);
end

%% Functions and new datapoints -------------------------------------------
[y,f] = M2M_functions(summary,ic,N,snaps);

%% 2 combinations ---------------------------------------------------------
[results_save] = M2M_twocombo(y,ic,N,snaps);

%% New approach -----------------------------------------------------------
[best_comb] = M2Marea(results_save,errordata,y,ic,y_0,t_period,statenames);
for i = 1:24
    B(i,1)=best_comb{i,5};
end
%% Plots ------------------------------------------------------------------
M2M_plot
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