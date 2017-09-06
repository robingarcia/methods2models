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

% kk
% mexmodel = eval(sprintf('@%s',mexmodelname)); %!!!
%Check inputs
if exist('timeF','var')
    input.tF = timeF;
else
    timeF = 0:1000;%1000;%linspace(0,1000,1*1000);%0:3000;
    input.tF = timeF;
end

if exist('N','var')
    input.N = N;
else
    N = 500;
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
[ic,data,errordata,y_0,t_period,N,snaps,time] = M2M_data_generation(input);
% minmax(t_period(1,:))
% minmax(t_period(2,:))
% minmax(t_period(3,:))
% minmax(t_period(4,:))
% minmax(t_period(5,:))
% minmax(t_period(6,:))

%% Purge datasets ---------------------------------------------------------
[errordata,~,nzero] = M2M_purge(errordata);
[ic, ~] = M2M_purge(ic);
[y_0, ~] = M2M_purge(y_0);
statenames = statenames(nzero);

%% Wanderlust analysis ----------------------------------------------------
[w_data,w_path] = pre_wanderlust(errordata,y_0,statenames,t_period);


%% Pre computation --------------------------------------------------------
for j = 1% 1 measurement output
summary = M2M_combinatorics(w_data,w_path,t_period,ic,errordata,statenames,j);
end

%% Functions and new datapoints -------------------------------------------
[y,f] = M2M_functions(summary,ic,N,snaps);

%% 2 combinations ---------------------------------------------------------
[results_save] = M2M_twocombo(y,ic,N,snaps);

%% New approach -----------------------------------------------------------
[best_comb] = M2Marea(results_save,errordata,y,ic,y_0,t_period,statenames);
B = zeros(24,1);
for i = 1:24
    B(i,1)=best_comb{i,5};
end
%% Plots ------------------------------------------------------------------
% M2M_plot
%% Save area --------------------------------------------------------------
results = ([]);
results.names = statenames;
results.ic = ic;
results.time = time;
results.N = N;
results.snaps = snaps;
results.data = data;
results.errordata = errordata;
results.y_0 = y_0;
results.t_period = t_period;
results.f = f;
results.best_comb = best_comb;
results.B = B;
results.input = input;
end