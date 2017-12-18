function [g1_phase,s_phase,g2_phase] = M2M_duration(statevalues,ub,lb,period)
%This function calculates the duration of the cell cycle phases.
%   Detailed explanation goes here
% [Syntax]
% [g1_phase,s_phase,g2_phase] = M2M_duration(statevalues,ub,lb,period)
% 
% [INPUT]
% statevalues        double| your statevalues
% ub                 double| upper bound
% lb                 double| lower bound
% period             double| Period of the cell cycle [h]
% 
% [OUTPUT]
% g1_phase           double| Length of the G1-Phase [h]
% s_phase            double| Length of the S-Phase [h]
% g2_phase           double| Length of the G2-Phase [h]
%
% [EXAMPLE]
% Pending!

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

%% Determine the peaks of your Cyclines and Cdc20A during cellcycle
        [~,locs5]=findpeaks(statevalues(lb:ub,5),'MinPeakDistance',20,'MinPeakHeight',0.07);
        [~,locs4]=findpeaks(statevalues(lb:ub,4),'MinPeakDistance',20,'MinPeakHeight',0.3);
        g1_s = locs5;% CycE(end)-locs12(end-1);
        s_g2 = locs4;% pB(end)-locs12(end-1);
        s = s_g2 - g1_s;        
        g1_phase = g1_s;
        s_phase = s;   
        g2_phase = period-locs4;  
end


