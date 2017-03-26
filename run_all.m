%% Run all in one step
%addpath(genpath('~/methods2models'));
%addpath(genpath('~/methods2models'));
%a = addpath(genpath('~/methods2models'));
%tic
filename = datestr(now,30); %Timestamp
dt = input('Input stepzise (e.g: [0.1]):');
tmax = input('Input simulation time (e.g: [100]):');
tF = 0:dt:tmax; % Simulation Time
n = input('How many cells? (e.g: [20]):');% n new datasets
%m = input('How many snapshots? (e.g: [20]):');% Number of snapshots
% ----------------------------------------------------------Data generation
tic
rndmic = lognrnd_ic(n);
toc

tic
simdata = cell(1,n);
random_statevalues = cell(1,n);
for i = 1:n
   this_IC = rndmic{i};
   simdata{i} = model_toettcher2008MEX(tF,this_IC); %MEX or mex?
   %simdata{i} = model_toettcher2008MEX(t_iqm,this_IC); %MEX or mex? 
   random_statevalues{i} = simdata{1,i}.statevalues;
end
toc
%% --------------------------------------------------------------Measurement
tic
[START, SAMPLES,t_period] = timepoints_template(random_statevalues, tF);
toc
% --------------------------------------------------------Simulate the model
%m = input('How many snapshots? (e.g: [20]):');
tic
rndm_measurement = cell(1,n);
measurement = cell(1,n);
%rndm_measurement = cell(1,length(SAMPLES));
tspan = zeros(1,n+1);
t_period = cell2mat(t_period);

for i = 1:n %:length(SAMPLES) // How many snapshots? i = 1 snapshot
    samples = sort(SAMPLES{1,i}(1,:));
    tspan(:,(2:length(tspan))) = samples; %Set t0 = 0
    simulationIC = START{2,i}(1,:); %APC peak = start = IC = t0
    simulationIC = simulationIC((1:31));
    simulationIC = simulationIC';
rndm_measurement{i} = model_toettcher2008MEX(tspan,simulationIC);
%rndm_measurement = model_toettcher2008MEX(tspan,simulationIC);

y_DNA = DNAcontent(tspan,t_period(1,i))';
%y_DNA = piecewise(tspan, t_period(1,i))';
figure(2)
hold on;
%axis([1000 length(y_DNA) 1 4.5])
plot(y_DNA)
hold off;
%rndm_measurement{1,i}.statevalues = horzcat(rndm_measurement{1,i}.statevalues, y_DNA);
%measurement{1,i} = rndm_measurement{1,i}.statevalues; %Save statevalues only
end
toc
%

%% Simulate DNA
%yDNA = DNAcontent(tspan, t_period{1,1})
%axis([0 2*pi -1.5 1.5])
%figure(2)
%plot(y_DNA);
%hold on;
%% Plot yout dataset
%scatter(newdata(1,:), newdata(2,:))
%for i = 1:n
    
%data = measurement{1,1}';
%scatter(data(32,:),data(5,:));
%end
%% Merge?
% Build workspace
%for i = 1:n
%Dcell = measurement{1,i};
%end
%Dmat = cell2mat(Dcell);

%% Save workspace
%Save workspace w/ timestamp (Save statevalues only)
%directoryname = uigetdir('~/methods2models/');
%directoryname = input('Directory? (e.g:~/methods2models/ ):');
%cd(directoryname);
%save(['~/methods2models/datasets/' filename '.mat'], 'random_statevalues', '-v7.3');
%save([filename '.mat'], 'random_statevalues','t_iqm','SAMPLES','rndm_measurement', '-v7.3');
%save([filename '.mat'],'rndm_measurement');
%cd('~/methods2models')
%toc

%% Plot yout dataset
%scatter(newdata(1,:), newdata(2,:))
