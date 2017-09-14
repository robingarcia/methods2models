function [y_DNA ] = M2M_DNAsimulation(time,T,G1,S)
%This function simulates the DNA duplication during cell cycle (2N -> 4N)
%The simulated DNA is needed in order to determine the start and the end of   
%the cell cycle.
% [SYNTAX]
% [ y_DNA ] = DNAcontent(time,T,G1,S)
% 
% [INPUT]
% time:       number: Time interval
% T:          number: Cell cycle period
% G1:         number: Length of G1 phase
% S:          number: Length of S phase
% 
% [OUTPUT]
% y_DNA:      number: Simulated DNA
% Example:
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
% G1 = G1/T; % Neccessary??
% S = S/T;   % Neccessary??

% dS = T*(S-G1);  %Duration of S-Phase
% G1 = T*G1;      % Duration G1-Phase
slope = 2/S;   % Slope between 2N -> 4N
y_DNA = zeros(1,length(time));
f_3=@(time)(slope.*time+(2-(slope*G1)));
y_DNA(time < G1) = 2;
y_DNA(time > G1+S) = 4;
y_DNA(time >= G1 & time <= G1+S) = f_3(time(time >= G1 & time <= G1+S));
end


