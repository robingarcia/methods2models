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
%Specifiy your needs
tF = 0:0.1:120; % Simulation Time
n = 2;           % n new datasets
profile on
% Load the MATLAB-model
matlab_model = model_toettcher2008matlab(tF);
% Load the IQM-model
iqm_model = model_toettcher2008iqm(tF);
% Load the MEX-model
mex_model = model_toettcher2008mex(tF);
% Verificate  IQM vs MATLAB
tic
run verification_iqm.m;
toc

% Verificate  MEX vs MATLAB
tic
run verification_mex.m;
toc

% Verificate  IQM vs MEX
tic
run verification_iqm_mex.m;
toc

% Change default ICs (Gaussian)
tic
random_ic = lognrnd_ic(n);
toc

% Check distribution of new ICs

% Generate data
tic
generation_temp(n);
toc

% Data2Wanderlust


% Print report

% Github


