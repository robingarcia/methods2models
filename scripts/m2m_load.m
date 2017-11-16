% Load predefined values
if exist('timeF','var')
    input.tF = timeF;
else
    timeF = linspace(0,1000,1000);
    input.tF = timeF;
end

if exist('N','var')
    input.N = N;
else
    N = 500;%300
    input.N = N;
end

if exist('snaps','var')
    input.snaps = snaps;
else 
    snaps = 2;%2
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
%% Store parameters
parameterID = fopen(['p' filename '.txt'],'w');%Save used parameters
fprintf(parameterID,'%12s', 'Time:');
fprintf(parameterID,'%12.0f\n',timeF(end));
fprintf(parameterID,'%12s', 'N:');
fprintf(parameterID,'%12.0f\n',N);
fprintf(parameterID,'%12s', 'snaps:');
fprintf(parameterID,'%12.0f\n',snaps);
fprintf(parameterID,'%12s', 'sig:');
fprintf(parameterID,'%12.4f\n',sig);
fprintf(parameterID,'%12s', 'model:');
fprintf(parameterID,'%12s\n',func2str(mexmodel));
fclose(parameterID);
type(['p' filename '.txt']);