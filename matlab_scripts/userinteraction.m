function [filename,tF,lb,n,ic] = userinteraction
% This function submits parameters like simulation time, cell number etc. 
% 
% 
% [Syntax]
% [filename,tF,lb,n,ic] = userinteraction
% 
% [INPUT]
% tmax:           number: How long should the simulation run
% tF:             number: The interval from 0 to tmax
% lb:             number: Determine your interval of interest (lower bound)
% n:              number: How many cells should be simulated?
% inputpath:      string: Set path where your IC inputfiles are stored
% inputfile:      string: Choose your input file
% 
% [OUTPUT]
% filename:       string: Timestamp ('yyyymmddTHHMMSS') used as filename
% tF:             number: see above
% lb:             number: see above
% n:              number: see above
% ic:             number: The initial conditions which were imported from your *.csv file

addpath(genpath('~/methods2models'));
filename = datestr(now,30); %Timestamp
load('toettcher_statenames.mat');
tmax = input('Input simulation time (e.g: [100]):');
tF = 0:tmax; % Simulation Time
X = ['Max. simulation time is:', num2str(tmax), '[s]'];
disp(X);
lb = input('Start timepoint t_1? (e.g: [2800]):');
n = input('How many cells? (e.g: [20]):');% n new datasets
cd('~/methods2models/datasets/input/');
disp(pwd);
inputpath = input('Where are your input files?:','s');% set a path
cd(inputpath);
ls -l
inputfile = input('Which *.csv file?:','s');% choose file
ic = csvread(inputfile);
cd('~/methods2models/');

end

