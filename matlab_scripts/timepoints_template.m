function [START, SAMPLES,t_period,G] = timepoints_template(random_statevalues,t_iqm)
%% This is an template for output generation
%clear ;
%clc;
%addpath /Users/robin/methods2models/ /Users/robin/MATLAB/
%% Load the data
%filename = uigetfile('~/methods2models/datasets');
%datafile = importdata(filename);
load('toetcher_statenames.mat');
%statevalues = datafile.random_statevalues; % States
statevalues = random_statevalues; % States
%t = datafile.t_iqm; % Time
%timepoints = datafile.t_iqm;
t = t_iqm; % Time
timepoints = t_iqm;
%t_original=timepoints./timepoints(end); %0 to 1
n = length(statevalues); % Determine the number of cells
m = length(t);
%m2 = m*0.1;
o = m - 100;
t=t(o:m); %Trimmed time vector
%t_norm = t-t(1); % Set the time vector from 0 to x
%t_cut=t./t(end); %0 to 1
PKS = zeros(n);
for i = 1:n
    m = length(statevalues{1,i});
o=m-100;%o = m - 100;
statevalues{1,i} = statevalues{1,i}((o:m),:); % Cut your dataset
end
%% Determine the peaks of your Cyclines and APC during cellcycle
j = [2,3,4,5,6,7,12]; %States which should be analyzed
F = cell(5,length(j));
G = cell(4,n);
for i = 1:n        % i = Number of cells
    for j = [2,3,4,5,6,7,12]    % j = States
    %onecell = statevalues{1,i}(:,j); % Take 1 from n cells
    %figure;
    %hold on;
    %findpeaks(statevalues{1,i}(:,j), 'MinPeakDistance', 25);
    %legend('Cyclin A','Peak Cyc A','Cyclin B','Peak Cyc B', 'Cyclin E','Peak Cyc E', 'APC','Peak APC', 'APCP','Peak APCP');
    [pks,locs, widths, proms]=findpeaks(statevalues{1,i}(:,j), 'MinPeakDistance', 28, 'MinPeakHeight',0.05);
    

AverageDistance_Peaks = mean(diff(locs));
    F{1,j} = pks;        %Peakvalue
    F{2,j} = locs;       %Position
    F{3,j} = widths;     %
    F{4,j} = proms;      %Prominence
    F{5,j} = AverageDistance_Peaks;
    G{1,i} = F;
    %T = pdist(G{1,i}{2,6});  %Calculate the period
    end
    % Calculation of the cell cylce period
    T = (G{1,i}{2,6});  %Calculate the period
    T=T(end)-T(end-1); %APC Period (=Cellcycle period)
    G{2,i} = T; %Period of the cell cycle
    PKS= G{1,i}{1,6};
    t_period(1,i) = G{2,i};
    %Triple-Peak
    %triplePeak{1,i}(i,1) = G{1,i}{2,5};
    %triplePeak{1,i}(i,2) = G{1,i}{2,4};
    %triplePeak{1,i}(i,3) = G{1,i}{2,12};
    
    % APC Period
    T = G{1,i}{2,6}(end);
    
    % G1/S-Transition
    CycETransEnd = G{1,i}{2,5}(end-1);
    
    % S/G2-Transition
    pBTransEnd = G{1,i}{2,4}(end-1);
    
    % M/G1-Transition
    Cdc20ATransMinus = G{1,i}{2,12}(end-2);
    
    
    % Duration G1-Phase
    g1Duration = CycETransEnd - Cdc20ATransMinus;
    G{3,i} = g1Duration;
    % Duration S-Phase
    sDuration = pBTransEnd - Cdc20ATransMinus;
    sDuration = sDuration - g1Duration;
    G{4,i} = sDuration;
    
    % This step is important to correct shifts (Workaround!!!)
    if G{3,i} > G{2,i} ; % Should smaller than the cellcycle period
    G{3,i} = G{3,i} - G{2,i};
    if G{4,i} < 0 ;% Should not be negative
        G{4,i} = G{4,i} + G{2,i};
    end
end
    
    %G1(1,i) = G{3,i}; % Duration G1-Phase for all cells
    %S(1,i) = G{4,i};  % Duration S-Phase for all cells
    
    
    %l_state(i,1) = length(G{1,i}{2,4}); %Length of the vector
    %l_state(i,2) = length(G{1,i}{2,5}); %Length of the vector
    %l_state(i,3) = length(G{1,i}{2,12}); % Length of the vector
    
    
end

%findpeaks(statevalues{1,i}(:,j), 'MinPeakDistance', 10);
%% Plot all peaks
% for j = 5 %[2,3,4,5,6,7,12]
%    for i = 1:n
%     onecell(:,i)=statevalues{1,i}(:,j);
%     figure(1)
%     hold on;
% %    s(j)=subplot(3,3,j);
%     findpeaks(onecell(:,i),'MinPeakDistance', 25);
%     %findpeaks(onecell(:,i),'MinPeakDistance', 25);
%     title(s(j),statenames(1,j));
% %    hold off;   
%    end
%    end

%% Determine the period of the cell cycle
% See Ln 42 (F{2,j} = locs;)
for i = 1:n
    for j = [2,3,4,5,6,7,12]
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
% +++++++ Delete this part ++++++++++
% Determine the slope: m = (4-2)/x2-x1
%for i = 1:n
    %z = G{2,i}; % Same value as T
    %z = G{1,i}{2,6};
%    interval = size(t);
    %time = linspace(interval(1,1), interval(1,2));
%    time = (1:interval(end));
    %time = t?
    %Design of vectors
%two=(1:length(time));
%two(1:length(time)) = 2;

%four=(1:length(time));
%four(1:length(time)) = 4;

%y = zeros(1,length(time));
%y(1:length(time))=2;

%for k = 1:length(G{1,i}{2,6})
%    z = G{1,i}{2,6}(k,1);
%p_g1 = z*0.5; % Duration G1-Phase
%p_s = z*0.3;  %Duration S-Phase
%p_g2 = z*0.16; % Duration G1-Phase
%p_gm = z*0.04; %p_g2 Duration G2-Phase
%slope = abs(2/(p_g2 - p_g1));
%t_1 = z/2;
%t_2 = 0.8*z;
%slope = (2/(t_2 - t_1));

%slpe = (1:length(time));
%slpe(1:length(time)) = 2;
%slpe = slpe+slope.*time;

%a=two((time>=0) & (time < p_g1)); 
%b=slpe((time>=p_g1) & (time < (p_g1+p_s)));
%c=four((time>=(p_g1+p_s)) & (time <= z));
    
%y=[a,b,c];
%figure(5)
%hold on;
%dnaplot=plot(y);
%grid on;
%    xlabel('Time')
%    ylabel('DNA')
%    title('Changes in DNA content')
    %hold off;


%DNA = y';
%szDNA = size(DNA,1);
%DNAzeros = zeros(length(statevalues{1,1}),1);
%DNAzeros([1:szDNA])=DNA;
%statevalues{1,i}(:,32)=DNAzeros;
%figure(43)
%plot(statevalues{1,i}(:,32));
%hold on;
%statevalues{1,i}(:,32)=DNA;
%DNAzeros = [DNA;zeros(length(statevalues{1,i}-length(DNA),1]
%statevalues{szDNA(1,1),szDNA(1,2),i}(:,32) = DNA;
%end
%end
%% Plot the beginning of the cellcycle
% See above
%% Choose arbitrary timepoints (Inverse method)
%gamma = zeros(1,n); % n-cells = n different gammas
syms a gammma p P x
%a = (0:T); % Interval
%gamma = zeros(1,length(a));
%p=@(a,gamma)(2*gamma*exp(-gamma(i)*a));
%GAMMA = zeros(1,n);
%samples = zeros(1,n);
%measurement = zeros(n,31); %n measurements
for i = 1:n
    gammma = log(2)/G{2,i}; % g = Growth rate of the population; T = period 
    GAMMMA(1,i) = gammma;
    %Pseu = randi(G{2,i});                % Uniform distributed numbers
    %a = linspace(0,T,n); %a = (G{2,i}); % Interval with period T (???)
    a = (0:G{2,i}); % Plotting range
    p=@(gammma,a)(2*gammma*exp(-gammma*a));  %Distribution function (pdf)
    P=@(a,gammma)((2-2*exp(-gammma*a)));    %Primitive (cdf)
    %x=@(gamma)((log(-2/(rand-2))/gamma));   %Inverse cdf (icdf)
    x=@(gammma)(log(-(rand-2)/2)/-gammma);
    samples(1,i) = x(gammma);                %Exponential distributed number
    %distfun(1,i) = p(gamma,a);
    
    
    %figure(900)
    %subplot(2,2,1) % PDF Plot
    %h=histogram(x(gamma));
    %hold on;
    %plot(a,(p(gamma,a)));
    %hold on;
    %grid on;
    %xlabel('Age [h]');
    %ylabel('Celldensity');
    %title('Distribution Function (pdf)');
    %hold off;
    
    %subplot(2,2,2) % CDF Plot
    %plot(a,P(a,gamma));
    %hold on;
    %grid on;
    %xlabel('Age [h]');
    %ylabel('Celldensity');
    %title('Primitive Function (cdf)')
    %hold off;
end
%figure(900)
    %subplot(2,2,1) % PDF Plot
    %h=histogram(samples,'Normalization','pdf');
    %hold on;
    %plot(a,distfun*n);
    %hold on;
    %grid on;
    %xlabel('Age [h]');
    %ylabel('Celldensity');
    %title('Distribution Function (pdf)');
%% Inverse method alorithm
    %rand('seed', 12345)
    %hold on;
    SAMPLES = cell(1,n);
    %samples = cell(1,n);
    samples = zeros(1,n);
    %t_period = cell(1,n);
    measurement = zeros(n,32); %n measurements
    for i = 1:n
        gammma = log(2)/G{2,i};
        
    
    %Draw proposal samples
    P = rand(1,n); %Create uniform distributed pseudorandom numbers (How to choose n? Does it must be equal?)
    %figure(400)
    %hist(P);
    %Evaluate Proposal samples at the inverse cdf
    %pd = makedist('exp');
    %z = G{2,i};
    %x=@(P,gamma)((log((2-gamma)./2))./P);
    x=@(P,gammma)((log(-2./(P-2))/gammma));
    samples = x(P,gammma); %ceil or round
    %SAMPLES{1,i} = samples;
    
    
    %Plot the distributions
    
    %figure(400)
    %subplot(2,2,1)
    %hist(P);
    %hold on;
    %grid on;
    %xlabel('Timepoints');
    %ylabel('Frequency');
    %title('Uniform Distribution [0,1]');
    
    %subplot(2,2,2)
    %hist(samples);
    %hold on;
    %grid on;
    %xlabel('Timepoints');
    %ylabel('Frequency');
    %title('Exponential Distribution');
    
    %Compose measurement dataset
    %measurement(i,:) = statevalues{1,i}(samples(1,i),:);
    %samples = samples-1;
    SAMPLES{1,i} = samples;
    
    %t_period(1,i) = G{2,i};
    %MEASUREMENT{1,i} = measurement;
    end
    %hold off;    
%% Save the measurement dataset
% Select arbitrary results from a given dataset
%filename = datestr(now,30);
%filename=strcat('m', filename);
%directoryname = uigetdir('~/methods2models/');
%save([filename '.mat'], 'measurement','-v7.3');
%cd('~/methods2models');
%% Plot all Cyclines

% for i = 1:n
% j = [2,3,5,6,7];
% combos = nchoosek(j,2);
% r = length(combos);
% f = gobjects(1,r);
% for q=1:r
% %figure(2)
% %hold on;
% %subplot(3,4,q)
% %f(q)=plot(statevalues{1,i}(:,combos(q,1)),statevalues{1,i}(:,combos(q,2)), 'k.');
% %hold on;
% %for i = 1:n %Plot the start of the cell cycle
%     %startpoint = G{1,i}{2,6}; % {2,6} = Localization of the APC-peak
%     %lstartpoint = length(startpoint);
%     %for k = 1:lstartpoint
% %f(q)=plot(statevalues{1,i}(startpoint(k,1),combos(q,1)),statevalues{1,i}(startpoint(k,1),combos(q,2)),'r*');
%     %end
%     
% %Plot the measurements
% %f(q)=plot(statevalues{1,i}(samples(1,i),combos(q,1)),statevalues{1,i}(samples(1,i),combos(q,2)),'go') ;
%     
% %end
% %xlabel(statenames(1,combos(q,1)))
% %ylabel(statenames(1,combos(q,2)))
% %title('Simulated Dataset')
% %hold off;
% end
% end

%% New simulated IC (extracted from a simulation = cellcycle start)
START = cell(2,n);
for i = 1:n
    startpoint = G{1,i}{2,6}; %Choose 3-4 periods (But only one period is required here!)
    START{1,i} = startpoint; % Startpoints of the cellcycle
    simstart_IC = zeros(length(startpoint),31);
    for j = 1:1:size(startpoint,1)
        %n = startpoint(j,1);
        simstart_IC(j,:) = statevalues{1,i}(j,:); % IC at the start
        START{2,i} = simstart_IC; %New IC from simulated dataset
    end
    
end
%% Print some information
% Define names 
Cells = n;
Period = mean([G{2,:}]);
%SimulationTime = datafile.t_iqm(end);
SimulationTime = t_iqm(end);

GrowthRate = mean(GAMMMA(1,:));
RESULTS = table(Cells,SimulationTime, Period, GrowthRate);
disp(RESULTS);

end
