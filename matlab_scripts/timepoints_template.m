%% This is an template for output generation
clear ;
clc;
%% Load the data
filename = uigetfile('~/methods2models/datasets');
datafile = importdata(filename);
load('toetcher_statenames.mat');
statevalues = datafile.random_statevalues; % States
t = datafile.t_iqm; % Time
n = length(statevalues); % Determine the number of cells
m = length(t);
o = m - 100;
t=t(o:m); %

for i = 1:n
    m = length(statevalues{1,i});
o = m - 100;
statevalues{1,i} = statevalues{1,i}([o:m],:); % Cut your dataset
end
%% Determine the peaks of your Cyclines and APC during cellcycle
for i = 1:n;
    for j = 1:31
    onecell = statevalues{1,i}(:,j); % Take 1 from n cells
    findpeaks(onecell);
    hold on;
    [pks,locs]=findpeaks(onecell);
    pks = findpeaks(onecell); % Hight of the peak
    locs = findpeaks(onecell); % Position of the peak
    end
end
%% Plot all Cyclines

%% Determine the period of the cell cycle

%% Simulate the duplication of the DNA 2 -> 4

%% Plot the beginning of the cellcycle

%% Choose arbitrary timepoints

%% Create new dataset with timepoints
