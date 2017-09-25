% Load predefined values
if exist('timeF','var')
    input.tF = timeF;
else
    timeF = linspace(0,1000,2*1000);
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