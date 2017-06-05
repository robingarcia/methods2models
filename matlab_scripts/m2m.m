function [result_areaS,result_areaA,result_combn] = m2m
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%% Datageneration ---------------------------------------------------------
[ic,mydata,errordata,y_0,t_period,N,snaps] = data_generation;%(tmax,tF,lb,N,sig,snapshots);

%% Wanderlust analysis ----------------------------------------------------
[result_areaS,result_areaA,result_combn]=wanderlust_analysis(errordata,ic,y_0,t_period,N,snaps);
