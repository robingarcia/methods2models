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
addpath(genpath('~/methods2models'));
%Specifiy your needs
dt = 0.1;
tmax = 100;
tF = 0:dt:tmax; % Simulation Time
n = 20;           % n new datasets
%profile on

% Load the MATLAB-model
matlab_model = model_toettcher2008matlab(tF);

% Load the IQM-model
iqm_model = model_toettcher2008iqm(tF);

% Load the MEX-model
mex_model = model_toettcher2008mex(tF);
% Verificate  IQM vs MATLAB
%verification_iqm(tF); % Bug?

% Verificate  MEX vs MATLAB
%verification_mex(tF);

% Verificate  IQM vs MEX
%verification_iqm_mex(tF);

% Change default ICs (Gaussian)
%random_ic = lognrnd_ic(n);

% Generate data (+check distribution of new ICs)
generation_temp(n,tF);

% Check for oscillation
frequence = check4oscillation;

% Data2Wanderlust
%script_data2variance;

% Print report

% Github

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
