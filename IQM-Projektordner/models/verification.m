%% Script for model verification

% Define scriptname
tmp = tempname;
mkdir(tmp);
runtmp = fullfile (tmp, 'final_model_modified.m');
demodir = fullfile (


% Run MATLAB model
run(scriptname);

% Define outputs MATLAB model
disp('      CycA     TriA     TriA21')
disp(ATotal)

disp('      CycE     TriE     TriE21')
disp(ETotal)

disp('      Cyc20A')
disp(Cdc20ATotal)

disp('      CycB       pB       BCKI     pBCKI     TriB21')
disp(BTotal)

% Define outputs IQM model




% Calculate the difference
