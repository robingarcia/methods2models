%% Sim.Dataset -> Measurement.Dataset
% Start of the cell cycle --> max. APC concentration
filename = uigetfile('~/methods2models/datasets');
datafile = importdata(filename);
load('toetcher_statenames.mat');
random_statevalues = datafile.random_statevalues;
t_iqm = datafile.t_iqm;
% Define retention time
p_g1 = (8/18);
p_s = (7/18);
p_gm = 1- (p_g1 + p_s);
t= t_iqm;
n = length(random_statevalues);
m = length(t_iqm);
APC = zeros(m,n);
T = zeros(1,n);
slope = zeros(1,n);
for i = 1:n
    x=random_statevalues{1,i}; %This are our cells
    apc =x(:,16); % 16 = APC
    APC(:,i) = apc;
    findpeaks(APC(:,i));
    [pks, locs,w,p]=findpeaks(APC(:,i));
    APCpeak=findpeaks(APC(:,i));
    w_length=length(w);
    W = w(w_length,:);
    T(:,i) = W; %Period duration per cell
    %f:= t-> piecewise(0<=t<p_g1*T(:,i), 2, p_g1*T(:,i)<=t<(p_g1*T(:,i)+p_s*T(:,i)), 2+(slope*t),(p_g1*T(:,i)+p_s*T(:,i)<=t<T(:,i)),4);
    %f(t);
    function y = DNA(t,T,slope)
% Piecewise defined function
% Call y = DNA(t)

y = 2 .*(t>=0 & t < p_g1*T(:,i));
y = 2+slope*t .* (t>=p_g1*T(:,i) & t < (p_g1*T(:,i)+p_s*T(:,i)));
y = 4 .* (t>=(p_g1*T(:,i)+p_s*T(:,i)) & t <= T(:,i));
    end
f = @DNA;
end

