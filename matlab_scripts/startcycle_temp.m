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
o = m - 1000;
t=t(o:m);

Xpart = zeros(length(t),n);
T = zeros(1,n);
%szAPC = size(APC);
%szT = size(T);
F = cell(2,5);
%CT = cell(szT);
%slope = zeros(1,n);
%soi=soi{2,3,5,6,7}; %state of interest
% Calculate APC property
for k = [2,3,5,6,7]
    for i = 1:n
    x=random_statevalues{1,i}; %This are our cells
    x_part =x((o:m),k); % 6 = APC
    Xpart(:,i) = x_part;
    figure(1)
    hold on;
    subplot(3,3,k)
    findpeaks(Xpart(:,i));
    [pks,locs]=findpeaks(Xpart(:,i));
    Xpartpeak=findpeaks(Xpart(:,i));
    T(:,i) = locs(end)-locs(end-1); %Period of the cyclines and APC
     
    end
    F{1,k} = Xpartpeak;
    F{2,k} = T;
    F{3,k} = Xpart;
    
end

%%%%%%%%%%%%%%%%
v = [2,3,5,6,7];
combos = nchoosek(v,2);
r = length(combos);
for q=1:r;
figure(2)
subplot(3,4,q)
plot(F{3,combos(q,1)},F{3,combos(q,2)}, 'bo');
end
%%%%%%%%%%%%%%%%
apc = F{2,6};   % M-Phase
apcp = F{2,7};
cyc_a = (F{2,2})./apc; % S-Phase
cyc_b = (F{2,3})./apc; % G2-Phase
cyc_e = (F{2,5})./apc; % G1-Phase
apc_norm = apc ./apc;

    t_2 = locs(length(locs)); % Was wird hier genau berechnet? 
    t_1 = locs(length(locs)-1);
    t_3 = t_2 - t_1;
    

%Duration of the cell cycle phases (from: The cell: a molecular approach.
%2nd edition
p_g1 = apc*0.5; % Duration G1-Phase
p_s = apc*0.3;  %Duration S-Phase
p_g1 = apc*0.16; % Duration G1-Phase
p_gm = apc*0.04; %p_g2 Duration G2-Phase



x1 = p_g1;
x2 = cyc_e + cyc_a;
x3 = x2-x1;
y=(1:length(x3));
y(1:50) = 2;
slope = (1:length(x3));
slope = (y./(x3)); 


% Simulate the duplication of the DNA 2n -> 4n
%for i = 1:n
    %z = apc(1,i);
    %q = slope(1,i)
    
    z = t_3;
    q = slope;
y = DNA(t_3,q,z,p_g1, p_s, n);
figure(3)
plot(y, 'r-')
%end


% Doublingrate
gamma = zeros(1,n);
gamma = log(2)./T; % Growth rate of the population



% Plot the simulated dataset
%for i = 1:n
    
%plot(random_statevalues{1,n}(:,2), random_statevalues{1,n}(:,3))
%hold on
%end

% Distribution
a = rand(50,1)';
X = distribution_func(a, gamma);
