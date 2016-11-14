%% Script for model verification

% Define scriptname
tmp = tempname;
mkdir(tmp);
runtmp = fullfile (tmp, 'final_model_modified.m');
demodir = fullfile (


% Run MATLAB model
run(scriptname);

% Define outputs
