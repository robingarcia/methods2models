%% Sim.Dataset -> Measurement.Dataset
% Start of the cell cycle --> max. APC concentration
clear ;
clc;

filename = uigetfile('~/methods2models/datasets');
datafile = importdata(filename);
load('toetcher_statenames.mat');
random_statevalues = datafile.random_statevalues;
t_iqm = datafile.t_iqm;

t= t_iqm;
n = length(random_statevalues); % Length of statevalues
m = length(t_iqm); % Length of time
o = m - 100;
t=t(o:m);

Xpart = zeros(length(t),n);
T = zeros(1,n);

%szAPC = size(APC);
%szT = size(T);
%F = cell(2,5);
%CT = cell(szT);
%slope = zeros(1,n);
%soi=soi{2,3,5,6,7}; %state of interest
% Calculate APC property
for k = [2,3,5,6,7] % This are our states
    for i = 1:n % 
    x=random_statevalues{1,i}; %This are our cells
    x_part =x((o:m),k);
    Xpart(:,i) = x_part;
    
    figure(1)
    hold on;
    s(k)=subplot(3,3,k);
    findpeaks(Xpart(:,i));
    title(s(k),statenames(1,k));
    
    [pks,locs]=findpeaks(Xpart(:,i));
    %Xpartpeak=findpeaks(Xpart(:,i));
    T(:,i) = locs(end)-locs(end-1); %Period of the cyclines and APC
    pks = findpeaks(Xpart(:,i));
    locs = findpeaks(Xpart(:,i));
    
    end
    F{1,k} = locs; %Peakvalue
    F{2,k} = T;         %Periods
    F{3,k} = Xpart;     %
    %F{4,k} = locs;      % Location of the peak
end
%no_2 = [F{4,2}, F{1,2}];
%no_3 = [F{4,3}, F{1,3}];
%no_5 = [F{4,5}, F{1,5}];
%no_6 = [F{4,6}, F{1,6}];
%no_7 = [F{4,7}, F{1,7}];
for k = [2,3,5,6,7];
    figure(2)
    hold on
findpeaks(x((o:m),k));
%legend('Cyclin A','CycA Peak', 'Cyclin B','CycB Peak', 'Cyclin E','CycE Peak', 'APC','APC Peak', 'APCP','APCP Peak');
end

%%%%%%%%%%%%%%%%
v = [2,3,5,6,7];
combos = nchoosek(v,2);
r = length(combos);
for q=1:r;
figure(3)
subplot(3,4,q)
plot(F{3,combos(q,1)},F{3,combos(q,2)}, 'b.');
xlabel(statenames(1,combos(q,1)))
ylabel(statenames(1,combos(q,2)))
end
%%%%%%%%%%%%%%%%
apc   = F{2,6};   % M-Phase
apcp  = F{2,7};
cyc_a = (F{2,2})./apc; % S-Phase
cyc_b = (F{2,3})./apc; % G2-Phase
cyc_e = (F{2,5})./apc; % G1-Phase
%apc_norm = apc ./apc;
apc = apc./apc;

t_2(1:n) = locs(length(locs)); % What do you calculate here? 
t_1(1:n) = locs(length(locs)-1);
t_3 = t_2 - t_1;
%delta_t =  t_iqm(locs(end)-locs(end-1));   

%Duration of the cell cycle phases (from: The cell: a molecular approach.
%2nd edition
p_g1 = apc*0.5; % Duration G1-Phase
p_s = apc*0.3;  %Duration S-Phase
p_g2 = apc*0.16; % Duration G1-Phase
p_gm = apc*0.04; %p_g2 Duration G2-Phase
%p_g1 = apc_norm - 
%p_s = 
%p_g2 =
%p_gm = 
%summ_dur = 
% Calculate the slope of 2N -> 4N
x1 = p_g1;
x2 = cyc_e + cyc_a;
x3 = x2-x1;
yy=(1:n);
yy(1:n) = 2;
slope = (1:n);
slope = (yy./(x3)); 


% Simulate the duplication of the DNA 2n -> 4n (still buggy)
for i = 1:n
    z = apc;
    q = slope;
    
    %z = t_3;
    %q = slope;
y(1,i) = DNA(slope,n,t,apc);
figure(4)
hold on;
plot(y(1,i), 'r-')
end


% Doublingrate
gamma = zeros(1,n); % n-cells = n different gammas
gamma = log(2)./T; % Growth rate of the population; T = period



% Plot the simulated dataset
%for i = 1:n
    
%plot(random_statevalues{1,n}(:,2), random_statevalues{1,n}(:,3))
%hold on
%end

%Choose random timepoints
% Distribution
a = rand(n,1)'; %Generate uniformly distributed random numbers
%for i = 1:n;
%X_distr(:,i) = distribution_func(a, gamma(:,i)); %Uniform-Distribution
% figure(6)
% hold on;
% hist(X_distr(:,i))
% plot(T,X_distr(:,i))
% 
% X_primitive(:,i) = primitive(a, gamma(:,i));
% figure(7)
% hold on
% hist(X_primitive(:,i))
% plot(T,X_primitive(:,i))
% 
% fprimi = X_primitive;
% fprimi=fprimi';
% X_inverse(:,i) = inverse(fprimi, gamma);
% figure(8)
% hold on
% hist(X_inverse(:,i))
% plot(T,X_inverse(:,i))
% end
