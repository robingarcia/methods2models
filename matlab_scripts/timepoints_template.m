function [start, samples,T] = timepoints_template(random_statevalues,lb,N,snaps)
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
%m = length(t);
% statevalues_cut = cell(1,N);
% for i = 1:N
%     m = length(statevalues{1,i});
% statevalues_cut{1,i} = statevalues{1,i}((lb:m),:); % Cut your dataset
% end
%% Determine the peaks of your Cyclines and APC during cellcycle
% j = [4,5]; %States which should be analyzed
% F = zeros(1,j(end));
T = zeros(4,N);
Tstart = zeros(1,N);
for i = 1:N        % i = Number of cells
    for k = 12 %6=APC 7=APCP 12=Cdc20a
%         [~,locs2]=findpeaks(statevalues{1,i}((lb:m),k),'MinPeakHeight',0.1);
        [~,locs2]=findpeaks(statevalues{1,i}(:,k),'MinPeakHeight',0.1);
        %Calculate the period of APC
        T(1,i)=locs2(end)-locs2(end-1); %APC Period (=Cellcycle period)
%         T(1,i)=locs2(end-1)-locs2(end-2); %APC Period (=Cellcycle period)
        Tstart(1,i) = locs2(end-1); %Tstart marks the begin of the period
        
        
%         for j = 4:5 %[4,5]    % j = States (5=CycE, 4=pB)
%             [~,locs]=findpeaks(statevalues_cut{1,i}((locs2(end-1):locs2(end)),j),'MinPeakHeight',0.05);
            [~,locs5]=findpeaks(statevalues{1,i}((locs2(end-1):locs2(end)),5),'MinPeakHeight',0.05);
            [~,locs4]=findpeaks(statevalues{1,i}((locs2(end-1):locs2(end)),4),'MinPeakHeight',0.05);
%             F(j) = locs;
            % Duration G1-Phase
%             CycETransEnd = locs5;%F(5);%-1;
            T(2,i) = locs5;%CycETransEnd;
            %Duration G1+S-Phase (= S/G2 transition)
%             pBTransEnd = locs4 - locs5;% F(4)-F(5);%-1;
            T(3,i) = locs4-locs5;%pBTransEnd;
            %Duration G2-Phase
            T(4,i) = T(1,i)-locs4;
%         end
    end
end
%% Inverse method alorithm
samples = zeros(N,snaps);%N=cells and snaps = # timepoints
P_value = zeros(N,snaps);% Delete this?
start = zeros(N,size(random_statevalues{1,1},2));
    for i = 1:N
        gammma = log(2)/T(1,i); % G{2,i}; % G{2,i} is the period!
        P = rand(1,snaps);% Number of cells (=n) or time (=m)?
        x=@(P,gammma)((log(-2./(P-2))/gammma));
        samples(i,:) = x(P,gammma); %ceil or round
        P_value(i,:) = P;
    %end   
%% New simulated IC (extracted from a simulation = cellcycle start)
    startpoint = Tstart(1,i); %Choose 3-4 periods (But only one period is required here!)
    %start{1,i} = startpoint-1; % Startpoints of the cellcycle
%     A = statevalues_cut{1,i};
        A = statevalues{1,i};
    start(i,:) = A(startpoint,:); %New IC from simulated dataset
    end
end
