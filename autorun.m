%% Connecting single cell methods to cell cycle models
% This file contains everything to run your experiment automatically
% PLEASE READ THE INSTALL.md FILE FIRST
%filename = datestr(now,30);
%publish('autorun.m', 'pdf'); %PDF Report
%publish('autorun.m', 'latex'); %LaTeX Report
%options = struct('format','pdf','outputDir','~/methods2models/reports/');
%clear all;
%clc all;
%close all;
%mkdir datasets reports
addpath(genpath('~/methods2models'));
%Specifiy your needs
dt = input('Input stepzise (e.g: [0.1]):');
tmax = input('Input simulation time (e.g: [100]):');
tF = 0:dt:tmax; % Simulation Time
n = input('How many cells? (e.g: [20]):');           % n new datasets
%profile on

%% Load the cell cycle models
% Load the MATLAB-model
matlab_model = model_toettcher2008matlab(tF);

% Load the IQM-model
[toet2008, toettcher2008, IC] = model_toettcher2008iqm(tF);

% Load the MEX-model
mex_model = model_toettcher2008mex(tF,IC);
% Verificate  IQM vs MATLAB
%verification_iqm(tF); % Bug?

%% Verification of the models
% Verificate  MEX vs MATLAB
%verification_mex(tF);

% Verificate  IQM vs MEX
%verification_iqm_mex(tF);

%% Data generation
% Change default ICs (Gaussian)
%random_ic = lognrnd_ic(n);

% Generate data (+check distribution of new ICs)
generation_temp(n,tF);

% Check for oscillation
%frequence = check4oscillation;

%% Measurement

%timepoints_template
[A,B,C] = timepoints_template;

%Simulate the model
%for i = 1:length(C)
    tF = sort(C{1,i});
    simulationIC = B{2,1}(1,:);
mex_model = model_toettcher2008mex(tF,simulationIC);
%end
%% Data2Wanderlust
%script_data2variance;

% Print report

% Github

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
