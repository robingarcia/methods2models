function[Y,combi,cmatrix] = M2M_Cmatrix(i,j,n, errordata) 
%% Create C-Matrix
%This function selects your measurement.
%
% [SYNTAX]
% [Y,combi,cmatrix] = M2M_Cmatrix(i,j,n, errordata)
%
%  [INPUT]
%  i:             number: Number of combinations
%  j:             number: Number of measurement outputs
%  n:             number: Number of cells
%  errordata:     number: Dataset
%  
%  [OUTPUT]
%  Y:             Number: Measured dataset
%  combi:         String: Measurement combination
%  cmatrix:       Number: ?
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

x = 1:n-1; %Substract the DNA part
C = nchoosek(x,j);% C-Code (MEX) from Jan Simon WChooseK
cmatrix = zeros(size(C,2), n); %Row= Measurement output
measure_out = C(i,:); % i = Select the row
for k = 1:length(measure_out)
cmatrix(k,measure_out(k)) = 1;
end
% Outputs
Y = cmatrix*errordata;
combi = C(i,:); %Which measurement combination were choosen?
end