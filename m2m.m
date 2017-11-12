function [m2m_result] = m2m(timeF,N,snaps,sig,mexmodel,doplots)
% This function calculates the best measurement combination 
% 
% 
% [Syntax]
% [results] = m2m
% 
% [INPUT]
% See:                userinput
% 
% [OUTPUT]
% results:            struct: Results
%
% [EXAMPLE]
% results = m2m(0:800,100,12,0.001,'model_toettcher2008MEX',0)

%==========================================================================
%     methods2models
%     Copyright (C) 2017  Robin Garcia Victoria
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%==========================================================================
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

% %% -----------------------Analysis (stable)----------------------------------------
% disp('Analysis ----------------------------------------------------------')
% pre_results=M2M_analysis(input,storage);
% m2m_result.analysis=pre_results;

%% ----- Analysis (unstable) ------------------------------------------------------
best = M2M_analysis2(input,storage);
m2m_result.best=best;
%% Result processing section ------------------------------------------------------
m2m_processing
%% Save the results
m2m_save;
end