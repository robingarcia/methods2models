function [T,Tstart] = M2M_duration(statevalues)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%% Determine the peaks of your Cyclines and APC during cellcycle
T = zeros(4,1);
Tstart = zeros(1,1);

        [~,locs12]=findpeaks(statevalues(:,12),'MinPeakDistance',20,'MinPeakHeight',0.1);
        T(1) = locs12(end-1) - locs12(end-2);
        [~,locs5]=findpeaks(statevalues(locs12(end-2):locs12(end-1),5),'MinPeakDistance',20,'MinPeakHeight',0.07);
        [~,locs4]=findpeaks(statevalues(locs12(end-2):locs12(end-1),4),'MinPeakDistance',20,'MinPeakHeight',0.3);
        g1_s = locs5;%(end)-locs12(end-1);
        s_g2 = locs4;%(end)-locs12(end-1);
        s = s_g2 - g1_s;        
        g1_phase = g1_s;
        s_phase = s;         
        g2_phase = T(1)-locs4;%s_g2;        
        T(2) = g1_phase;
        T(3) = s_phase;
        T(4) = g2_phase;         
        Tstart(1) = locs12(end-2);  
end


