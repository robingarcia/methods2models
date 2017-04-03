%% Run all in one step
%addpath(genpath('~/methods2models'));
%addpath(genpath('~/methods2models'));
%a = addpath(genpath('~/methods2models'));
%tic
filename = datestr(now,30); %Timestamp
%load('toettcher_statenames.mat');
%dt = input('Input stepzise (e.g: [0.1]):');
tmax = input('Input simulation time (e.g: [100]):');
tF = 0:tmax; % Simulation Time
n = input('How many cells? (e.g: [20]):');% n new datasets
%m = input('How many snapshots? (e.g: [20]):');% Number of snapshots
% ----------------------------------------------------------Data generation
tic
rndmic = lognrnd_ic(n); % Generate gaussian distributed ICs
toc

tic
simdata = cell(1,n);
random_statevalues = cell(1,n);
for i = 1:n
   this_IC = rndmic{i};
   simdata{i} = model_toettcher2008MEX(tF,this_IC); %MEX or mex?
   %simdata{i} = model_toettcher2008MEX(t_iqm,this_IC); %MEX or mex? 
   random_statevalues{i} = simdata{1,i}.statevalues;%Why more timesteps as given above?
end
toc
%% --------------------------------------------------------------Measurement
tic
[START, SAMPLES,t_period,G_all,GAMMA] = timepoints_template(random_statevalues, tF);
toc

%% ---------------------------------------------Check for ergodic assumption
% Weak ergodic assumption

% Strong ergodic assumption
%% --------------------------------------------------------Simulate the model
%m = input('How many snapshots? (e.g: [20]):');
tic
rndm_measurement = cell(1,n);
measurement = cell(1,n);
%rndm_measurement = cell(1,length(SAMPLES));
%tspan = zeros(1,n+1);% ERROR HERE!!! (tspan duration has same length as one cell cycle?)
%t_period = cell2mat(t_period);
samples = SAMPLES; %WHY SORT???
for i = 1:n %length(samples); %:length(SAMPLES) %// How many snapshots? i = 1 snapshot
    %samples = sort(SAMPLES,2);%(SAMPLES{1,i}(1,:)); % Prepare your timepoints = cells
    tspan = horzcat(0,sort(samples(i,:)),t_period(1,i)); % time vector from 0 to 30 (set t0 = 0)
    %tspan = horzcat(samples(i,:),t_period(1,i)); % time vector from 0 to 30 (set t0 = 0)
    %tspan = 0:tspan;
    %tspan(:,(2:length(tspan))) = samples; %Set t0 = 0
    %tspan = samples;
    simulationIC = START{2,i}; %APC peak = start = IC = t0 (with (1,:) only one period is used here)
    %simulationIC = simulationIC((1:31));%What is happening here? o.O
    %simulationIC = simulationIC';
%--------------------------------------------------------------
% NEW SIMULATION (SNAPSHOTS)
rndm_measurement{i} = model_toettcher2008MEX(tspan,simulationIC);
%rndm_measurement = model_toettcher2008MEX(tspan,simulationIC);
%--------------------------------------------------------------

%-------------------------------------------------DNA Simulation
y_DNA = DNAcontent(tspan,t_period(1,i),t_period(2,i), t_period(3,i))'; %G_all{3,i}, G_all{4,i})';
%y_DNA = piecewise(tspan, t_period(1,i))';
figure(2)
hold on;
%axis([ 1.5 4.5])
plot(y_DNA)
grid on;
%hold off;
%---------------------------------------------------------------

rndm_measurement{1,i}.statevalues = horzcat(rndm_measurement{1,i}.statevalues, y_DNA); %Merge measurement-dataset with DNA simulation
measurement{1,i} = (rndm_measurement{1,i}.statevalues)'; %Save statevalues only
end
toc
%% Merge?
% Build workspace
tic
mydata = cell2mat(measurement);
toc
%% Plot your dataset
%scatterhist(newdata(1,:), newdata(2,:))
%scatter(mydata(32,:),mydata(5,:));
%% Save workspace
%Save workspace w/ timestamp (Save statevalues only)
%directoryname = uigetdir('~/methods2models/');
directoryname = input('Directory? (e.g:~/methods2models/ ):');
%cd(directoryname);
%save(['~/methods2models/datasets/' filename '.mat'], 'random_statevalues', '-v7.3');
%save([filename '.mat'], 'random_statevalues','t_iqm','SAMPLES','rndm_measurement', '-v7.3');
save([filename '.mat'],'mydata', '-v7.3');
cd('~/methods2models/')
%toc

% %% Plot yout dataset
% %-------------------------------------------------------- Plot all Cyclines
% % Update APC(6) position 
% %[pks,locs, widths, proms]=findpeaks(Dmat(6,:), 'MinPeakDistance', 28, 'MinPeakHeight',0.05);
% %startpoint = locs;
% %for i = 1:n
% j = [2,3,5,6,7];
% combos = nchoosek(j,2);
% r = length(combos);
% f = gobjects(1,r);
% for q=1:r
% figure(2)
% hold on;
% subplot(3,4,q)
% f(q)=scatter(Dmat(combos(q,1),:),Dmat(combos(q,2),:),[], 'k.');
% hold on;
% for i = 1:n %Plot the start of the cell cycle
%     startpoint = G_all{1,i}{2,6}; % {2,6} = Localization of the APC-peak (old peak position maybe?) --> Update with findpeaks required!
%     lstartpoint = length(startpoint);
%     for k = 1:lstartpoint
% f(q)=scatter(Dmat(combos(q,1),startpoint(k,1)),Dmat(combos(q,2),startpoint(k,1)),[],'r*');
%     end
%     
% %Plot the measurements
% %f(q)=plot(Dmat(samples(1,i),combos(q,1)),Dmat(samples(1,i),combos(q,2)),'go') ;
%     
% end
% xlabel(statenames(1,combos(q,1)))
% ylabel(statenames(1,combos(q,2)))
% title('Simulated Dataset')
% hold off;
% end
%end
