function [results] = m2m(timeF,N,snaps,sig,mexmodel,doplots)
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
addpath(genpath('~/methods2models'));
statenames = cell(1,32);
load('~/methods2models/datasets/toettcher_statenames.mat');
input.statenames=statenames;
% kk
% mexmodel = eval(sprintf('@%s',mexmodelname)); %!!!
%Check inputs
if exist('timeF','var')
    input.tF = timeF;
else
<<<<<<< HEAD
    timeF = linspace(0,1000,1*1000);%0:3000;
=======
    timeF = linspace(0,1000,2*1000);%0:3000;
>>>>>>> bugfix_at_3119102
    input.tF = timeF;
end

if exist('N','var')
    input.N = N;
else
    N = 2000;
    input.N = N;
end

if exist('snaps','var')
    input.snaps = snaps;
else 
    snaps = 2;
    input.snaps = snaps;
end

if exist('sig','var')
    input.sig = sig;
else 
    sig = 0.1;
    input.sig = sig;
end

if exist('mexmodel','var')
    mexmodel = eval(sprintf('@%s',mexmodel)); %!!!
    input.mexmodel = mexmodel;
else
    mexmodel = eval(sprintf('@%s','model_toettcher2008MEX'));
    input.mexmodel = mexmodel;
end

if exist('doplots','var')
    input.doplots = doplots;
else
    doplots = 0;
    input.doplots = doplots;
end
disp('This is your input:')
disp('-------------------')
disp(input)
%% Data generation --------------------------------------------------------
disp('Data generation ---------------------------------------------------')
[storage] = M2M_data_generation(input);


%% -----------------------Analysis-----------------------------------------
disp('Analysis ----------------------------------------------------------')
results=M2M_analysis(input,storage);


%% Plots ------------------------------------------------------------------
% M2M_plot
end