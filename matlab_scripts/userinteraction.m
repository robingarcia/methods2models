function [filename,tF,lb,n,ic] = userinteraction
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
addpath(genpath('~/methods2models'));
a = addpath(genpath('~/methods2models'));
filename = datestr(now,30); %Timestamp
%load('toettcher_statenames.mat');
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

