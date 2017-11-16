function [m2m_result] = m2m(timeF,N,snaps,sig,mexmodel,doplots)
% This function calculates the best measurement combination 
% 
% 
% [Syntax]
% [results] = m2m(timeF,N,snaps,sig,mexmodel,doplots)
% 
% [INPUT]
% timeF                 Simulation time
% N                     Number of cells
% snaps                 Number of snapshots
% sig                   Sigma (for error model)
% mexmodel              MEX file of your model
% doplots               0=no, 1=yes
% 
% [OUTPUT]
% results:              struct: Results
%
% [EXAMPLE]
% results = m2m(0:800,100,12,0.001,'model_toettcher2008MEX',0)
%
% [Structure]
% m2m_Toolbox
% |-- M2M_analysis
% |   |-- M2Marea
% |   |   |-- M2M_combo_wanderlust
% |   |   |   |-- PathfromWanderlust
% |   |   |   |   |-- getMeanWanderlustPath
% |   |   |   |   `-- wanderlust
% |   |   |   |-- sbistFACS2PathDensity
% |   |   |   `-- sbistFACSDensityTrafo
% |   |   `-- moving_average
% |   |-- M2M_combinatorics
% |   |   |-- M2M_Cmatrix
% |   |   |-- sbistFACS2PATHDensity
% |   |   `-- sbistFACSDensityTrafo
% |   |-- M2M_functions
% |   |   |-- moving_average
% |   |   `-- normdata
% |   |-- M2M_pre_wanderlust
% |   |   `-- PathfromWanderlust
% |   |       |-- getMeanWanderlustPath
% |   |       `-- wanderlust
% |   `-- M2M_twocombo
% `-- M2M_data_generation
%     |-- M2M_DNAsimulation
%     |-- M2M_duration
%     |-- M2M_error_model
%     |-- M2M_lognrnd
%     |-- M2M_mexmodel
%     |-- M2M_purge
%     |-- M2M_start
%     `-- M2M_timepoints

% profile on
m2m_init;
addpath(genpath(workpath));
addpath(genpath([storepath '/' 'm2mresults_' username]));
cd([storepath '/' 'm2mresults_' username '/output']);
filename = datestr(now,30);
m2m_load
m2m_result=([]);
m2m_result.filename=filename;
% workpath='~/methods2models';%Root directory of the m2m-toolbox
% addpath(genpath(workpath));
statenames = cell(1,32);
load toettcher_statenames.mat;
% load('~/methods2models/datasets/toettcher_statenames.mat');
input.statenames=statenames;
m2m_result.workpath=workpath;
m2m_result.storepath=storepath;
m2m_result.username=username;
% m2m_load
m2m_result.input=input;
%% Data generation --------------------------------------------------------
disp('Data generation ---------------------------------------------------')
[input,storage] = M2M_data_generation(input);
m2m_result.data_gen=storage;

%% -----------------------Analysis (stable)----------------------------------------
disp('Analysis ----------------------------------------------------------')
pre_results=M2M_analysis(input,storage);
m2m_result.analysis=pre_results;

%% ----- Analysis (unstable) ------------------------------------------------------
% best = M2M_analysis2(input,storage);
% m2m_result.best=best;
%% Result processing section ------------------------------------------------------
m2m_processing
%% Save the results
m2m_save;
%% Print the result
Result = horzcat(add_combi,add_area);
disp(table(Result)); %Display the result
m2m_thankyou %Thank you message
end