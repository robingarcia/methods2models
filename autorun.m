%% Connecting single cell methods to cell cycle models
% This file contains everything to run your experiment automatically
% PLEASE READ THE INSTALL.md FILE FIRST
%filename = datestr(now,30);
%publish('autorun.m', 'pdf'); %PDF Report
%publish('autorun.m', 'latex'); %LaTeX Report
%options = struct('format','pdf','outputDir','~/methods2models/reports/');
%clear all;
%clc all;
%mkdir datasets reports
%addpath(genpath('/~methods2models'));
%Specifiy your needs
tF = 0:0.1:1000; % Simulation Time
n = 2;           % n new datasets
%profile on
% Load the MATLAB-model
matlab_model = model_toettcher2008matlab(tF);

% Load the IQM-model
iqm_model = model_toettcher2008iqm(tF);
% Load the MEX-model
mex_model = model_toettcher2008mex(tF);
% Verificate  IQM vs MATLAB
run verification_iqm.m;

% Verificate  MEX vs MATLAB
run verification_mex.m;

% Verificate  IQM vs MEX
run verification_iqm_mex.m;

% Change default ICs (Gaussian)
random_ic = lognrnd_ic(n);

% Generate data (+checm distribution of new ICs)
generation_temp(n);

% Data2Wanderlust
%script_data2variance;

% Print report

% Github

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
