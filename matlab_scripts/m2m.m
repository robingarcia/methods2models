function [] = m2m(tmax,tF,lb,N,sig,snapshots)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%% Datageneration ---------------------------------------------------------
[ic,~,errordata,y_0,t_period] = data_generation(tmax,tF,lb,N,sig,snapshots);

%% Wanderlust analysis ----------------------------------------------------
wanderlust_analysis(errordata,ic,y_0,t_period)
