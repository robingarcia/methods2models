function [m2m_result] = m2m(timeF,N,snaps,sig,mexmodel,doplots,domail)
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
% results = m2m(0:1000,10000,10,0.01,'model_toettcher2008MEX',0)
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
profile on
% set(0,'DefaultFigureWindowStyle','docked');
filename = datestr(now,30);
timestamp{:}=filename;
m2m_result=([]);
m2m_result.filename=filename;
addpath(genpath('~/methods2models'));
statenames = cell(1,32);
load('~/methods2models/datasets/toettcher_statenames.mat');
input.statenames=statenames;
m2m_load
% %Check inputs
% if exist('timeF','var')
%     input.tF = timeF;
% else
%     timeF = linspace(0,1000,2*1000);%0:3000;
%     input.tF = timeF;
% end
% 
% if exist('N','var')
%     input.N = N;
% else
%     N = 2000;
%     input.N = N;
% end
% 
% if exist('snaps','var')
%     input.snaps = snaps;
% else 
%     snaps = 2;
%     input.snaps = snaps;
% end
% 
% if exist('sig','var')
%     input.sig = sig;
% else 
%     sig = 0.1;
%     input.sig = sig;
% end
% 
% if exist('mexmodel','var')
%     mexmodel = eval(sprintf('@%s',mexmodel)); %!!!
%     input.mexmodel = mexmodel;
% else
%     mexmodel = eval(sprintf('@%s','model_toettcher2008MEX'));
%     input.mexmodel = mexmodel;
% end
% 
% if exist('doplots','var')
%     input.doplots = doplots;
% else
%     doplots = 0;
%     input.doplots = doplots;
% end
mex_model{:}=mexmodel;
m2m_result.input=input;
disp('This is your input:')
disp('-------------------')
disp(table(timeF,N,snaps,sig,mex_model,doplots,timestamp))

%% Data generation --------------------------------------------------------
disp('Data generation ---------------------------------------------------')
[input,storage] = M2M_data_generation(input);
% [input,storage] = M2M_data_generation(timeF,N,snaps,sig,mexmodel,doplots);
% save([filename '.mat'], 'storage','-v7.3');
m2m_result.data_gen=storage;
if domail
m2m_mail('teb81338@stud.uni-stuttgart.de','Data generation',evalc('disp(m2m_result)'))
else
   disp('No notification') 
end
%% -----------------------Analysis-----------------------------------------
disp('Analysis ----------------------------------------------------------')
pre_results=M2M_analysis(input,storage);
m2m_result.analysis=pre_results;
if domail
m2m_mail('teb81338@stud.uni-stuttgart.de','Analysis',evalc('disp(m2m_result)'))
else 
    disp('No notification')
end
% %% ------------------ Results ---------------------------------------------
% disp('Results -----------------------------------------------------------')
% size(results.BEST{1,1},1)
% size(storage.BEST,2)
% for i = 1:size(storage.BEST,2)
%    for j = 1:size(results.BEST{1,1},1)
%        
%    end
% end
%% Plots ------------------------------------------------------------------
% M2M_plot
if doplots
M2M_report(m2m_result)
publish('M2M_report.m','pdf');
else
    disp('No report generated ===========================================')
end
%% Print the results
% clc
% fprintf('  Combination         Area')
% format short
% dataprint=[];

%% Save the results
save([filename '.mat'], 'm2m_result','-v7.3');
if domail
m2m_mail('teb81338@stud.uni-stuttgart.de','Workspace saved',evalc('disp(m2m_result)'))
else
   disp('No notification') 
end
%% Send notification
% m2m_mail('robing@selfnet.de','Test33','Daten erstellung war erfolgreich')
end