%% Script for data generation with autosave function
n = 3; %Number of datasets
%Load the 
rndmic = lognrnd_ic(n);

%Check new IC's (Distribution of IC's)
tic
rndmic = lognrnd_ic(n);
H = cell2mat(rndmic(:));
for i = 1:31
vector = H(:,i);
subplot(16,2,i);
histfit(vector)
end
toc

% Simulation time
t_iqm = 0:0.1:120;


%Simulation w/ updated ICs and extract updated statevalues
simdata = cell(1,n);
random_statevalues = cell(1,n);
for i = 1:n
   this_IC = rndmic{i};
   simdata{i} = model_toettcher2008mex(t_iqm, this_IC);
   random_statevalues{i} = simdata{1,i}.statevalues;
   
%Plot all statevalues
%figure(i);
%plot(t_iqm,random_statevalues{i});
%hold on;
%xlabel('Time')
%ylabel('States')
%axis tight

% Check for oscillation
%[autocor,lags] = xcorr(random_statevalues{i},120,'coeff');

%plot(lags/t_iqm,autocor)
%xlabel('Lag (min)')
%ylabel('Autocorrelation')
%axis([0 120 0 2])
end

%Extract timestamp
filename = datestr(now,30);

%Save workspace w/ timestamp (Save statevalues only)
save(['~/methods2models/datasets/' filename '.mat'], 'random_statevalues');

% Dataset2Wanderlust
% PATH muss auf datasets zeigen
