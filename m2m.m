function [results] = m2m
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
addpath(genpath('~/methods2models'));
load('~/methods2models/datasets/toettcher_statenames.mat');
%% Datageneration ---------------------------------------------------------
[ic,~,errordata,y_0,t_period,~,~] = data_generation;%(tmax,tF,lb,N,sig,snapshots);

%% Purge datasets
[errordata,~,nzero] = M2M_purge(errordata);
[ic, ~] = M2M_purge(ic);
[y_0, ~] = M2M_purge(y_0);
statenames = statenames(nzero);
%% Wanderlust analysis ----------------------------------------------------
% [results]=wanderlust_analysis(errordata,ic,y_0,t_period,statenames);
[w_data,w_path] = pre_wanderlust(errordata,ic,y_0,statenames,t_period);

%% Combinations -----------------------------------------------------------
Summary=cell(1,size(ic,1));%Preallocation
for j = [1,27]%1%:2
%     for i=1:size(WChooseK(1:size(ic,1),j),1)
summary = M2M_combinatorics(w_data,w_path,t_period,ic,errordata,statenames,j);
Summary{j} = summary;
%     end
end
results = cat(1,Summary{:});

%% Pure the results
tic
for i = 1:size(results,1)
%     results(i).s_E = M2M_purge(results(i).s_E);
%     results(i).a_E = M2M_purge(results(i).a_E);
%     results(i).Variance_S = M2M_purge(results(i).Variance_S);
%     results(i).Variance_A = M2M_purge(results(i).Variance_A);
    results(i).area_S = M2M_purge(results(i).area_S);
    results(i).area_A = M2M_purge(results(i).area_A);
    results(i).comb = results(i).comb(~cellfun('isempty',results(i).comb));
%     results(i).combn = results(i).combn(~cellfun('isempty',results(i).combn));
%     results(i).combinations = results(i).combinations(~cellfun('isempty',results(i).combinations));
end
toc

%% Area calculation -------------------------------------------------------
% Do it later!
%% Plots
%result_all = cat(1,sum_A(:).area_A); <-- I DID IT !!! \o/
%name_all = cat(1,results(:).combn); < -- IT WORKS !!!
%result_combn = categorical(result_combn);
%barh(result_combn,result_areaA)
% bar(result_areaA)
% set(gca,'XTickLabel',result_combn)
