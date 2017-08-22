function [results_save] = M2M_twocombo(y,ic,N,snaps)
% This function determines the best combination from 2 output measurements 
% 
% 
% [Syntax]
% [results_save] = M2M_twocombo(y,ic,N,snaps)
% 
% [INPUT]
% y:                numbers: Datapoints for all species
% ic:               numbers: Initial conditions
% N:                numbers: Number of cells
% snaps:            numbers: Number of snapshots
% 
% [OUTPUT]
% results_save:     struct: Results with the smallest area under curve and
% the best combination
%
% [EXAMPLE]
% Pending
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
x = normdata(linspace(0,1,N*snaps));
results_save = ([]);
z = 1:size(ic,1);% Number of parameters
for i = 2 %Only 2 combinations are considered here
    results_save.i = i;
    C = WChooseK(z,i);
    trap_area = zeros(1,size(C,1));
    for j = 1:size(C,1)
        y_1 = y(C(j,1),:);
        y_2 = y(C(j,2),:);
        y_previous = min(y_1,y_2);
        trap_area(1,j) = trapz(x,y_previous);
    end
end
[h,Track] = min(trap_area);
best = C(Track,:);
for j = Track
    y_1 = y(C(j,1),:);
    y_2 = y(C(j,2),:);
    y_previous = min(y_1,y_2);
end
results_save.best = best;%Best combination 2 from 27
results_save.h = h; %Area under curve
results_save.y_previous = y_previous;

end

