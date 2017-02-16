%% Sim.Dataset -> Measurement.Dataset
% Start of the cell cycle --> max. APC concentration
filename = uigetfile('~/methods2models/datasets');
datafile = importdata(filename);
load('toetcher_statenames.mat');
random_statevalues = datafile.random_statevalues;
t_iqm = datafile.t_iqm;
% Define retention time
%p_g1 = (8/18);
%p_s = (7/18);
%p_gm = 1- (p_g1 + p_s);
t= t_iqm;
n = length(random_statevalues); % Length of statevalues
m = length(t_iqm); % Length of time

APC = zeros(m,n);
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
    apc =x(:,k); % 6 = APC
    APC(:,i) = apc;
    %findpeaks(APC(:,i));
    [pks, locs,w,p]=findpeaks(APC(:,i));
    APCpeak=findpeaks(APC(:,i));
    w_length=length(w);
    W = w(w_length,:);
    T(:,i) = W; %Period duration per cell     
    end
    F{1,k} = APC;
    F{2,k} = T;
end

cyc_a = F{2,2}; % S-Phase
cyc_b = F{2,3}; % G2-Phase
cyc_e = F{2,5}; % G1-Phase
apc = F{2,6};   % M-Phase
apcp = F{2,7};

p_s = apc - cyc_b - cyc_e; 
p_g1 = apc - cyc_a - cyc_b;
p_gm = apc - cyc_e - cyc_a; %p_g2
%total = p_s + p_g1 + p_gm;
x1 = p_g1;
x2 = cyc_e + cyc_a;
x3 = x2-x1;
y=[1:length(x3)];
y(1:50) = 2;
slope = [1:length(x3)];
slope = (y./(x3)); 

%f:= t-> piecewise(0<=t<p_g1*T(:,i), 2, p_g1*T(:,i)<=t<(p_g1*T(:,i)+p_s*T(:,i)), 2+(slope*t),(p_g1*T(:,i)+p_s*T(:,i)<=t<T(:,i)),4);
    %f(t);
    %function y = DNA(t,T,slope)
% Piecewise defined function
% Call y = DNA(t)

%y = 2 .*(t>=0 & t < p_g1*T(:,i));
%y = 2+slope*t .* (t>=p_g1*T(:,i) & t < (p_g1*T(:,i)+p_s*T(:,i)));
%y = 4 .* (t>=(p_g1*T(:,i)+p_s*T(:,i)) & t <= T(:,i));
    %end

    
% Aufruf der Funktion
%for i = 1:n
    %z = apc(1,i);
    %q = slope(1,i)
    t_2 = locs(length(locs));
    t_1 = locs(length(locs)-1);
    t_3 = t_2 - t_1;
    z = apc;
    q = slope;
y = DNA(t_3,q,z,p_g1, p_s)
plot(y)
%end
