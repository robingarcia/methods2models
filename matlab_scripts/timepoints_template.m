%% This is an template for output generation
clear ;
clc;
%% Load the data
filename = uigetfile('~/methods2models/datasets');
datafile = importdata(filename);
load('toetcher_statenames.mat');
statevalues = datafile.random_statevalues; % States
t = datafile.t_iqm; % Time
n = length(statevalues); % Determine the number of cells
m = length(t);
o = m - 100;
t=t(o:m); %
PKS = zeros(n);
for i = 1:n
    m = length(statevalues{1,i});
o = m - 100;
statevalues{1,i} = statevalues{1,i}((o:m),:); % Cut your dataset
end
%% Determine the peaks of your Cyclines and APC during cellcycle
j = [1,2,3,5,6,7]; %States which should be analyzed
F = cell(5,length(j));
G = cell(2,n);
tic
for i = 1:n;        % i = Number of cells
    for j = [2,3,5,6,7];    % j = States
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
toc

%% Plot all peaks
for j = [2,3,5,6,7];
   for i = 1:n;
    onecell(:,i)=statevalues{1,i}(:,j);
    figure(1)
    hold on;
    s(j)=subplot(3,3,j);
    findpeaks(onecell(:,i),'MinPeakDistance', 15);
    title(s(j),statenames(1,j));
       
   end
end
%% Plot all Cyclines
j = [2,3,5,6,7];
combos = nchoosek(j,2);
r = length(combos);
for q=1:r;
figure(2)
subplot(3,4,q)
f(q)=plot(statevalues{1,i}(:,combos(q,1)),statevalues{1,i}(:,combos(q,2)), 'b.');
xlabel(statenames(1,combos(q,1)))
ylabel(statenames(1,combos(q,2)))
end
%% Determine the period of the cell cycle
% See Ln 42 (F{2,j} = locs;)
for i = 1:n;
    for j = [2,3,5,6,7];
peakInterval = diff(G{1,i}{2,j});
    figure(3)
    hold on;
    hist(peakInterval)
    grid on;
    xlabel('Period of the cell cycle')
    ylabel('Frequency of Occurrence')
    title('Histogram of Peak Intervals (Cell cycle period)')
    end
end
%% Simulate the duplication of the DNA 2 -> 4
% Determine the slope: m = (4-2)/x2-x1
for i = 1:n;
    z = G{2,i};
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
gamma = zeros(1,n); % n-cells = n different gammas
gamma = log(2)./T; % Growth rate of the population; T = period
end

%% Plot the beginning of the cellcycle

%% Choose arbitrary timepoints

%% Create new dataset with timepoints
