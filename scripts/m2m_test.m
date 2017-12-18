%% m2m_test
% Run this script in order to check operational reliability
% Dependencies of this toolbox
tic
filename = datestr(now,30);
diary
[fList,pList] = matlab.codetools.requiredFilesAndProducts('m2m.m');
fList=fList';
%% Load variables
if exist('timeF','var')
    input.tF = timeF;
else
    timeF = linspace(0,800,801);
    input.tF = timeF;
end

if exist('N','var')
    input.N = N;
else
    N = 300;%300
    input.N = N;
end

if exist('snaps','var')
    input.snaps = snaps;
else 
    snaps = 1;%2
    input.snaps = snaps;
end

if exist('sig','var')
    input.sig = sig;
else 
    sig = 0.02;
    input.sig = sig;
end

if exist('mexmodel','var')
    mexmodel = eval(sprintf('@%s',mexmodel));
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
% load toettcher_statenames.mat;
statenames = mexmodel('states')';
statenames{1,end+1}='DNA';
input.statenames=statenames;
disp(input)
%% Generate dataset
[input,storage] = M2M_data_generation(input);
disp(storage)
%% Calculate something
[B,new,scale]=M2M_combination(storage.errordata,storage.t_period,storage.statenames,storage.y_0,1:27);
disp(B)
disp(new)
disp(scale)
%% Report
diary([filename '.log'])
disp('Success!')
diary off
toc
clear