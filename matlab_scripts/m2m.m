function [result_areaS,result_areaA,result_combn] = m2m
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
load('toettcher_statenames.mat');
%% Datageneration ---------------------------------------------------------
[ic,~,errordata,y_0,t_period,N,snaps] = data_generation;%(tmax,tF,lb,N,sig,snapshots);

%% Purge datasets
[errordata,~,nzero] = M2M_purge(errordata);
[ic, ~] = M2M_purge(ic);
[y_0, ~] = M2M_purge(y_0);
statenames = statenames(nzero);
%% Wanderlust analysis ----------------------------------------------------
[result_areaS,result_areaA,result_combn]=wanderlust_analysis(errordata,ic,y_0,t_period,N,snaps,statenames);
