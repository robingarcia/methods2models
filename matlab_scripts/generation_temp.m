function [] = generation_temp (n)
%% Script for data generation with autosave function
%Extract timestamp
filename = datestr(now,30);
n = 1500; %Number of datasets (Filesize will be 2*n MB with t = 10000)
%Load the 
rndmic = lognrnd_ic(n);

%Check new IC's (Distribution of IC's)
tic
rndmic = lognrnd_ic(n);
H = cell2mat(rndmic(:));
for i = 1:31
vector = H(:,i);
subplot(4,8,i);
histogram(vector)
end
toc

% Simulation time (keep at 5000)
t_iqm = 0:2000;


%Simulation w/ updated ICs and extract updated statevalues
simdata = cell(1,n);
random_statevalues = cell(1,n);
for i = 1:n
   this_IC = rndmic{i};
   %simdata{i} = model_toettcher2008MEX(tF,this_IC); %MEX or mex?
   simdata{i} = model_toettcher2008MEX(t_iqm,this_IC); %MEX or mex? 
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



%Save workspace w/ timestamp (Save statevalues only)
directoryname = uigetdir('~/methods2models/');
cd(directoryname);
%save(['~/methods2models/datasets/' filename '.mat'], 'random_statevalues', '-v7.3');
save([filename '.mat'], 'random_statevalues','t_iqm','-v7.3');
cd('~/methods2models')
%T = array2table(random_statevalues);
%T = cell2table(random_statevalues);
%IQMexportCSVdataset(T, ['~/methods2models/datasets/csv/' filename ]);
% Dataset2Wanderlust
% PATH muss auf datasets zeigen
end
