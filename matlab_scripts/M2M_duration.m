function [T,Tstart] = M2M_duration(statevalues)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%% Determine the peaks of your Cyclines and APC during cellcycle
T = zeros(4,1);
Tstart = zeros(1,1);
    for k = 12 %6=APC 7=APCP 12=Cdc20a
%         [~,locs2]=findpeaks(statevalues{1,i}((lb:m),k),'MinPeakHeight',0.1);
        [~,locs12]=findpeaks(statevalues(:,12),'MinPeakHeight',0.1);
        [~,locs5]=findpeaks(statevalues(:,5),'MinPeakHeight',0.1);
        [~,locs4]=findpeaks(statevalues(:,4),'MinPeakHeight',0.1);
        
        findpeaks(statevalues(:,12),'MinPeakHeight',0.1);
        hold on
        findpeaks(statevalues(:,5),'MinPeakHeight',0.1);
        hold on
        findpeaks(statevalues(:,4),'MinPeakHeight',0.1);
        hold on
        
        g1_s = locs5(10)-locs12(10);
        s_g2 = locs4(10)-locs12(10);
        s = s_g2 - g1_s;
        cc_period = locs12(11)-locs12(10);
        g1_phase = g1_s;
        s_phase = s;
        g2_phase = locs12(11)-s_g2;
        T(1) = cc_period;
        T(2) = g1_phase;
        T(3) = s_phase;
        T(4) = g2_phase;
        Tstart(1) = locs12(10);
        close all
%         %Calculate the period of APC
%         T(1)=locs2(end)-locs2(end-1); %APC Period (=Cellcycle period)
% %         T(1,i)=locs2(end-1)-locs2(end-2); %APC Period (=Cellcycle period)
%         Tstart(1) = locs2(end-1); %Tstart marks the begin of the period
%         
%         
% %         for j = 4:5 %[4,5]    % j = States (5=CycE, 4=pB)
% %             [~,locs]=findpeaks(statevalues_cut{1,i}((locs2(end-1):locs2(end)),j),'MinPeakHeight',0.05);
%             [~,locs5]=findpeaks(statevalues((locs2(end-1):locs2(end)),5),'MinPeakHeight',0.05);
%             [~,locs4]=findpeaks(statevalues((locs2(end-1):locs2(end)),4),'MinPeakHeight',0.05);
% %             F(j) = locs;
%             % Duration G1-Phase
% %             CycETransEnd = locs5;%F(5);%-1;
%             T(2) = locs5;%CycETransEnd;
%             %Duration G1+S-Phase (= S/G2 transition)
% %             pBTransEnd = locs4 - locs5;% F(4)-F(5);%-1;
%             T(3) = locs4-locs5;%pBTransEnd;
%             %Duration G2-Phase
%             T(4) = T(1)-locs4;
% %         end
    end
end


