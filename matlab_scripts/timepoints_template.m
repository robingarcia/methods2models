%% This is an template for output generation
clear ;
clc;
%addpath /Users/robin/methods2models/ /Users/robin/MATLAB/
%% Load the data
filename = uigetfile('~/methods2models/datasets');
datafile = importdata(filename);
load('toetcher_statenames.mat');
statevalues = datafile.random_statevalues; % States
t = datafile.t_iqm; % Time
timepoints = datafile.t_iqm;
%t_original=timepoints./timepoints(end); %0 to 1
n = length(statevalues); % Determine the number of cells
m = length(t);
%m2 = m*0.1;
o = m - 400;
t=t(o:m); %Trimmed time vector
%t_norm = t-t(1); % Set the time vector from 0 to x
%t_cut=t./t(end); %0 to 1
PKS = zeros(n);
for i = 1:n
    m = length(statevalues{1,i});
o=m-400;%o = m - 100;
statevalues{1,i} = statevalues{1,i}((o:m),:); % Cut your dataset
end
%% Determine the peaks of your Cyclines and APC during cellcycle
j = [1,2,3,5,6,7]; %States which should be analyzed
F = cell(5,length(j));
G = cell(2,n);
for i = 1:n        % i = Number of cells
    for j = [2,3,5,6,7]    % j = States
    %onecell = statevalues{1,i}(:,j); % Take 1 from n cells
    %figure(100+i);
    %hold on;
    %findpeaks(statevalues{1,i}(:,j), 'MinPeakDistance', 15);
    %legend('Cyclin A','Peak Cyc A','Cyclin B','Peak Cyc B', 'Cyclin E','Peak Cyc E', 'APC','Peak APC', 'APCP','Peak APCP');
    [pks,locs, widths, proms]=findpeaks(statevalues{1,i}(:,j), 'MinPeakDistance', 15);
    

AverageDistance_Peaks = mean(diff(locs));
    F{1,j} = pks;        %Peakvalue
    F{2,j} = locs;       %Position
    F{3,j} = widths;     %
    F{4,j} = proms;      %Prominence
    F{5,j} = AverageDistance_Peaks;
    G{1,i} = F;
    %T = pdist(G{1,i}{2,6});  %Calculate the period
    end
    T = (G{1,i}{2,6});  %Calculate the period
    T=T(end)-T(end-1); %APC Period (=Cellcycle period)
    G{2,i} = T;
    PKS= G{1,i}{1,6};
end
%% Plot all peaks
%for j = [2,3,5,6,7]
   %for i = 1:n
    %onecell(:,i)=statevalues{1,i}(:,j);
    %figure(1)
    %hold on;
    %s(j)=subplot(3,3,j);
    %findpeaks(onecell(:,i),'MinPeakDistance', 15);
    %findpeaks(onecell(:,i),'MinPeakDistance', 15);
    %title(s(j),statenames(1,j));
    %hold off;   
   %end
%end

%% Determine the period of the cell cycle
% See Ln 42 (F{2,j} = locs;)
for i = 1:n
    for j = [2,3,5,6,7]
peakInterval = diff(G{1,i}{2,j});
    %figure(3)
    %hold on;
    %hist_period = histogram(diff(G{1,i}{2,j}));
    %grid on;
    %xlabel('Period of the cell cycle')
    %ylabel('Frequency of Occurrence')
    %title('Histogram of Peak Intervals (Cell cycle period)')
    %hold off;
    
    end
end
%hist_period;
%% Simulate the duplication of the DNA 2 -> 4
% Determine the slope: m = (4-2)/x2-x1
for i = 1:n
    z = G{2,i}; % Same value as T
    interval = size(t);
    time = linspace(interval(1,1), interval(1,2));
    
    %Design of vectors
two=(1:length(time));
two(1:length(time)) = 2;

four=(1:length(time));
four(1:length(time)) = 4;

%y = zeros(1,length(time));
%y(1:length(time))=2;

p_g1 = z*0.5; % Duration G1-Phase
p_s = z*0.3;  %Duration S-Phase
p_g2 = z*0.16; % Duration G1-Phase
p_gm = z*0.04; %p_g2 Duration G2-Phase
slope = abs(2/(p_g2 - p_g1));

a=two ((time>=0) & (time < p_g1)); 
b=two((time>=p_g1) & (time < (p_g1+p_s)));
c=four((time>=(p_g1+p_s)) & (time <= z));
    
y=[a,b,c];
figure(5)
hold on;
plot(y);
grid on;
    xlabel('Time')
    ylabel('DNA')
    title('Changes in DNA content')
    hold off;
end

%% Plot the beginning of the cellcycle
% See above
%% Choose arbitrary timepoints (Inverse method)
%gamma = zeros(1,n); % n-cells = n different gammas
syms a gamma p P x
%a = (0:T); % Interval
%gamma = zeros(1,length(a));
%p=@(a,gamma)(2*gamma*exp(-gamma(i)*a));
GAMMA = zeros(1,n);
samples = zeros(1,n);
%measurement = zeros(n,31); %n measurements
for i = 1:n
    gamma = log(2)/G{2,i}; % g = Growth rate of the population; T = period 
    GAMMA(1,i) = gamma;
    %Pseu = rand;                % Uniform distributed numbers
    %a = linspace(0,T,n); %a = (G{2,i}); % Interval with period T (???)
    a = (0:G{2,i}); % Plotting range
    p=@(a,gamma)(2*gamma*exp(-gamma*a));  %Distribution function (pdf)
    P=@(a,gamma)((-2*exp(-gamma.*a))+2);    %Primitive (cdf)
    x=@(gamma)((log(-2/(rand-2))/gamma));   %Inverse cdf (icdf)
    samples(1,i) = x(gamma);                %Exponential distributed number
    %samples = samples./n;
    
    
    figure(900)
    subplot(2,2,1) % PDF Plot
    %histogram(samples);
    hold on;
    h=plot(a,p(a,gamma));
    hold on;
    grid on;
    xlabel('Age [h]');
    ylabel('Celldensity');
    title('Distribution Function (pdf)');
    %hold off;
    
    subplot(2,2,2) % CDF Plot
    H=plot(a,P(a,gamma));
    hold on;
    grid on;
    xlabel('Age [h]');
    ylabel('Celldensity');
    title('Primitive Function (cdf)')
    %hold off;
end

%% Inverse method alorithm
    %rand('seed', 12345)
    %hold on;
   
    %samples = cell(1,n);
    samples = zeros(1,n);
    measurement = zeros(n,31); %n measurements
    for i = 1:n
        gamma = log(2)/G{2,i};
        
    
    %Draw proposal samples
    P = rand; %Create uniform distributed pseudorandom numbers
    %figure(400)
    %hist(P);
    %Evaluate Proposal samples at the inverse cdf
    %pd = makedist('exp');
    %z = G{2,i};
    %x=@(P,gamma)((log((2-gamma)./2))./P);
    x=@(P,gamma)((log(-2/(P-2))/gamma));
    samples(1,i) = ceil(x(P,gamma)); %ceil or round
    
    
    
    %Plot the distributions
    
    figure(400)
    subplot(2,2,1)
    histogram(P);
    hold on;
    grid on;
    xlabel('Timepoints');
    ylabel('Frequency');
    title('Uniform Distribution [0,1]');
    
    subplot(2,2,2)
    histogram(samples);
    hold on;
    grid on;
    xlabel('Timepoints');
    ylabel('Frequency');
    title('Exponential Distribution');
    
    %Compose measurement dataset
    measurement(i,:) = statevalues{1,i}(samples(1,i),:);
    end
    %hold off;
    
%% Save the measurement dataset
% Select arbitrary results from a given dataset
filename = datestr(now,30);
filename=strcat('m', filename);
directoryname = uigetdir('~/methods2models/');
save([filename '.mat'], 'measurement','-v7.3');
cd('~/methods2models');
%% Plot all Cyclines

for i = 1:n
j = [2,3,5,6,7];
combos = nchoosek(j,2);
r = length(combos);
f = gobjects(1,r);
for q=1:r
figure(2)
hold on;
subplot(3,4,q)
f(q)=plot(statevalues{1,i}(:,combos(q,1)),statevalues{1,i}(:,combos(q,2)), 'k.');
hold on;
%for i = 1:n %Plot the start of the cell cycle
    startpoint = G{1,i}{2,6}; % {2,6} = Localization of the APC-peak
    lstartpoint = length(startpoint);
    for k = 1:lstartpoint
f(q)=plot(statevalues{1,i}(startpoint(k,1),combos(q,1)),statevalues{1,i}(startpoint(k,1),combos(q,2)),'r*');
    end
    
%Plot the measurements
f(q)=plot(statevalues{1,i}(samples(1,i),combos(q,1)),statevalues{1,i}(samples(1,i),combos(q,2)),'go') ;
    
%end
xlabel(statenames(1,combos(q,1)))
ylabel(statenames(1,combos(q,2)))
title('Simulated Dataset')
hold off;
end
end
%% Print some information
% Define names 
Cells = n;
Period = mean([G{2,:}]);
SimulationTime = datafile.t_iqm(end);
GrowthRate = mean(GAMMA(1,:));
RESULTS = table(Cells,SimulationTime, Period, GrowthRate);
disp(RESULTS);
%% Save your measurements
%directoryname = uigetdir('~/methods2models/');


