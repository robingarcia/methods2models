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

APC = zeros(length(t),n);
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
    %apc =x(:,6); % 6 = APC
    apc =x((o:m),k); % 6 = APC
    APC(:,i) = apc;
    findpeaks(APC(:,i));
    [pks,locs]=findpeaks(APC(:,i));
    APCpeak=findpeaks(APC(:,i));
    T(:,i) = locs(end)-locs(end-1);
     
    end
    F{1,k} = APCpeak;
    F{2,k} = T;
end

apc = F{2,6};   % M-Phase
apcp = F{2,7};
cyc_a = (F{2,2})./apc; % S-Phase
cyc_b = (F{2,3})./apc; % G2-Phase
cyc_e = (F{2,5})./apc; % G1-Phase
apc = apc ./apc;

    t_2 = locs(length(locs)); % Was wird hier genau berechnet? 
    t_1 = locs(length(locs)-1);
    t_3 = t_2 - t_1;
%p_s = apc - cyc_b - cyc_e;
p_s=[1:length(n)];
p_s(1:n) = 0.4;
%p_g1 = apc - cyc_a - cyc_b;
p_g1=[1:length(n)];
p_g1(1:n) = 0.3;
%p_gm = apc - cyc_e - cyc_a; %p_g2
p_gm=[1:length(n)];
p_gm(1:n) = 0.3;
total = p_s + p_g1 + p_gm;


x1 = p_g1;
x2 = cyc_e + cyc_a;
x3 = x2-x1;
y=(1:length(x3));
y(1:50) = 2;
slope = (1:length(x3));
slope = (y./(x3)); 


% Aufruf der Funktion
%for i = 1:n
    %z = apc(1,i);
    %q = slope(1,i)
    
    z = t_3;
    q = slope;
y = DNA(t_3,q,z,p_g1, p_s, n);
plot(y, 'r-')
%end


% Doubling
gamma = zeros(1,n);
gamma = log(2)./T; % Growth rate of the population



% Plot the simulated dataset
%for i = 1:n
    
%plot(random_statevalues{1,n}(:,2), random_statevalues{1,n}(:,3))
%hold on
%end

% Calculate the growth
%p @(a) (2*gamma * exp(-gamma*a);
