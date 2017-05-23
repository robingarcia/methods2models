function [START, samples,T,G,GAMMMA] = timepoints_template(random_statevalues,t_iqm,o)
% This is an template for output generation
% This function generates the snapshots
% 
% [SYNTAX]
% [START, samples,T,G,GAMMMA] = timepoints_template(random_statevalues,t_iqm,o)
% 
% [INPUTS]
% random_statevalues
% t_iqm
% o
% 
% [OUTPUTS]
% START
% samples
% T
% G
% GAMMMA
%--------------------------------------------------------------------------
%% Load the data
statevalues = random_statevalues; % States

t = t_iqm; % Time
n = length(statevalues); % Determine the number of cells
m = length(t);
statevalues_cut = cell(1,n);
for i = 1:n
    m = length(statevalues{1,i});
statevalues_cut{1,i} = statevalues{1,i}((o:m),:); % Cut your dataset
end
%% Determine the peaks of your Cyclines and APC during cellcycle
j = [2,3,4,5,6,7,12]; %States which should be analyzed
F = cell(5,length(j));
G = cell(4,n);
T = zeros(3,n);
Tstart = zeros(1,n);
for i = 1:n        % i = Number of cells
    for k = 6
        [~,locs2]=findpeaks(statevalues{1,i}((o:m),k));
        for j = [2,3,4,5,7,12]    % j = States
    
    [~,locs, widths, proms]=findpeaks(statevalues_cut{1,i}((locs2(end-1):locs2(end)),j),'MinPeakHeight',0.05);
    
    AverageDistance_Peaks = diff(locs2);
    AverageDistance_Peaks = AverageDistance_Peaks(end);
    %F{1,j} = pks;        %Peakvalue
    F{2,j} = locs;       %Position
    F{3,j} = widths;     %
    F{4,j} = proms;      %Prominence
    F{5,j} = AverageDistance_Peaks;
    F{6,k} = locs2;
    G{1,i} = F;
    
    %Calculate the periods of all proteins
    
    
        end
    end
    T(1,i)=locs2(end)-locs2(end-1); %APC Period (=Cellcycle period)
    Tstart(1,i) = locs2(end-1);
    
    CycETransEnd = G{1,i}{2,5}-1;
    
    pBTransEnd = G{1,i}{2,4}-1;
    
    % Duration G1-Phase
    g1Duration = CycETransEnd; %- Cdc20ATransMinus;
    
    T(2,i) = g1Duration/T(1,i);
    
    sDuration = pBTransEnd; %- Cdc20ATransMinus;
    
    T(3,i) = sDuration/T(1,i); %G{1, i}{5, 6};
end

%% Inverse method alorithm
    m = 2;
    samples = zeros(n,m);%n=cells and m = timepoints
    
    GAMMMA = zeros(1,n); %Just preallocation
    for i = 1:n
        gammma = log(2)/T(1,i); % G{2,i}; % G{2,i} is the period!
        GAMMMA(1,i) = gammma;
    
    P = rand(1,m);% Number of cells (=n) or time (=m)?
    
    x=@(P,gammma)((log(-2./(P-2))/gammma));
    samples(i,:) = x(P,gammma); %ceil or round
    end   
%% New simulated IC (extracted from a simulation = cellcycle start)
START = cell(2,n);
for i = 1:n
    startpoint = Tstart(1,i); %Choose 3-4 periods (But only one period is required here!)
    START{1,i} = startpoint-1; % Startpoints of the cellcycle

             A = statevalues_cut{1,i};
        
        START{2,i} = A(startpoint-1,:); %New IC from simulated dataset
end
%% Print some information
% Define names 
Cells = n;
Period = mean(T(1,:));
%SimulationTime = datafile.t_iqm(end);
SimulationTime = t_iqm(end);

GrowthRate = mean(GAMMMA(1,:));
RESULTS = table(Cells,SimulationTime, Period, GrowthRate);
disp(RESULTS);

end
