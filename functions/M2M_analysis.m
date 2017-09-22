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
time_pre=tic;
[w_data,w_path] = pre_wanderlust(errordata,y_0,statenames,t_period);
% [w_path] = pre_wanderlust(errordata,y_0,statenames,t_period);
toc(time_pre)

%% Pre computation --------------------------------------------------------
% Here, all states are calculated individually together with the DNA as a measurement parameter.
disp('Combinatorics')
time_combi=tic;
for j = 1% 1 measurement output
summary = M2M_combinatorics(w_data,w_path,t_period,ic,errordata,statenames,j);
end
toc(time_combi)
%% Functions and new datapoints -------------------------------------------
disp('Functions and new datapoints')
m2mfun_time=tic;
y= M2M_functions(summary,ic,N,snaps);
toc(m2mfun_time)
%% 2 combinations ---------------------------------------------------------
disp('2 combinations')
combi_time=tic;
% [results_save] = M2M_twocombo(y,ic,N,snaps);
[~,combi_store] = M2M_twocombo(y,ic,N,snaps);
toc(combi_time)

%% New approach (more combinations) ---------------------------------------
disp('New approach (more combinations)')
np_time=tic;
BEST=cell(1,size(combi_store,2));
for i= 1%1:size(combi_store,2)
results_save=combi_store{i};
[best_comb] = M2Marea(results_save,errordata,y,ic,y_0,t_period,statenames);
empties=find(cellfun(@isempty,best_comb));%Detect empty cells
best_comb(empties(1),:)=[];%Remove empty cells
BEST{i}=best_comb;
toc(np_time)
end
% Single values from cell to vector
% areas=zeros(size(best_comb,1),1);
% candidate=zeros(size(best_comb,1),1);
% for i=1:size(best_comb,1)
%     areas(i,1)=best_comb{i,5};
%     candidate(i,1)=best_comb{i,2};
% end
toc(np_time)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% New approach -----------------------------------------------------------
% disp('New approach')
% np_time=tic;
% [best_comb] = M2Marea(results_save,errordata,y,ic,y_0,t_period,statenames);
% B = zeros(24,1);
% for i = 1:24
%     B(i,1)=best_comb{i,5};
% end
% toc(np_time)
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
% results.best_comb = best_comb;
% results.B = B;
results.BEST = BEST;
results.input = input;
results.storage= storage;
end

