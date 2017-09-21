function [results] = M2M_analysis(input,storage)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


%% Extract your data
disp('Extract data')
N=input.N;
snaps=input.snaps;
ic=storage.rndmic;
% data=storage.mydata;
errordata=storage.errordata;
y_0=storage.y_0;
t_period=storage.t_period;
% time=storage.time;
statenames=storage.statenames;
%% Wanderlust analysis ----------------------------------------------------
% Here the trajectories for all states are calculated. 
% This corresponds to a model output of all simultaneously measured states.
disp('Wanderlust analysis (all states)')
[w_data,w_path] = pre_wanderlust(errordata,y_0,statenames,t_period);



%% Pre computation --------------------------------------------------------
% Here, all states are calculated individually together with the DNA as a measurement parameter.
disp('Pre computation')
for j = 1% 1 measurement output
summary = M2M_combinatorics(w_data,w_path,t_period,ic,errordata,statenames,j);
end

%% Functions and new datapoints -------------------------------------------
disp('Functions and new datapoints')
y= M2M_functions(summary,ic,N,snaps);

%% 2 combinations ---------------------------------------------------------
disp('2 combinations')
[results_save] = M2M_twocombo(y,ic,N,snaps);

%% New approach -----------------------------------------------------------
disp('New approach')
[best_comb] = M2Marea(results_save,errordata,y,ic,y_0,t_period,statenames);
B = zeros(24,1);
for i = 1:24
    B(i,1)=best_comb{i,5};
end
% %% Save area --------------------------------------------------------------
results = ([]);
% results.names = statenames;
% results.ic = ic;
% results.time = time;
% results.N = N;
% results.snaps = snaps;
% results.data = data;
% results.errordata = errordata;
% results.y_0 = y_0;
% results.t_period = t_period;
% results.f = f;
results.best_comb = best_comb;
results.B = B;
results.input = input;
results.storage= storage;
end

