function [T,Tstart] = M2M_duration(statevalues)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%==========================================================================
%     methods2models
%     Copyright (C) 2017  Robin Garcia Victoria
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%==========================================================================

%% Determine cell cycle start & left corner of your plateau
T = zeros(6,1);
Tstart = zeros(1,1);
% mydesire=statevalues(12,1:90)';
mydesire=statevalues(1:end,12);%12th column
find_result = find(mydesire<10^-3); %Find all values smaller than 10e-3
con=find_result(diff(find_result)==1);
zeroos=diff(con)==1;
plateaucorner=find(zeroos == 0);
cornerposition = plateaucorner+1;
position2=con(cornerposition);
T(1) = position2(end)-position2(end-1); %Cell cycle period
ub = position2(end); %upper bound
lb = position2(end-1);%lower bound
T(5)=ub;
T(6)=lb;
%% Determine the peaks of your Cyclines and Cdc20A during cellcycle


%         [~,locs12]=findpeaks(statevalues(:,12),'MinPeakDistance',20,'MinPeakHeight',0.1);%Cdc20A
%         T(1) = locs12(end-1) - locs12(end-2);

%         [~,locs5]=findpeaks(statevalues(locs12(end-2):locs12(end-1),5),'MinPeakDistance',20,'MinPeakHeight',0.07);
%         [~,locs4]=findpeaks(statevalues(locs12(end-2):locs12(end-1),4),'MinPeakDistance',20,'MinPeakHeight',0.3);
        [~,locs5]=findpeaks(statevalues(lb:ub,5),'MinPeakDistance',20,'MinPeakHeight',0.07);
        [~,locs4]=findpeaks(statevalues(lb:ub,4),'MinPeakDistance',20,'MinPeakHeight',0.3);
        g1_s = locs5;% CycE(end)-locs12(end-1);
        s_g2 = locs4;% pB(end)-locs12(end-1);
        s = s_g2 - g1_s;        
        g1_phase = g1_s;
        s_phase = s;         
        g2_phase = T(1)-locs4;%s_g2;        
        T(2) = g1_phase;
        T(3) = s_phase;
        T(4) = g2_phase;         
        Tstart(1) = lb;%locs12(end-2);  
end

