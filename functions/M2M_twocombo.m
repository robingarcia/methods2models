function [results_save,combi_store] = M2M_twocombo(y,ic,N,snaps)
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
x = linspace(0,1,N*snaps);%normdata(linspace(0,1,N*snaps));
results_save = ([]);
combi = ([]);
z = 1:size(ic,1);% Number of parameters
for i = 2 %Only 2 combinations are considered here
    results_save.i = i;
    C = WChooseK(z,i);% Two measurement outputs

    trap_area = zeros(1,size(C,1));
    for j = 1:size(C,1)
        y_1 = y(C(j,1),:);
        y_2 = y(C(j,2),:);
        y_previous = min(y_1,y_2);%Minimal value selected here
        trap_area(1,j) = trapz(x,y_previous);
    end
end

%% Smallest area under the curve for a particular combination
% [h,Track] = min(trap_area);
[h,Track] = sort(trap_area);% h= area under curve, Track = index of pos.
best = C(Track,:);
combi_store=cell(1,size(trap_area,2));
for k = 1:size(Track,2) 
%     disp(k)
    j=Track(k);%
    disp(C(j,:))
    y_1 = y(C(j,1),:);
    y_2 = y(C(j,2),:);
    y_previous = min(y_1,y_2);
    combination=C(j,:);
    area=trap_area(j);
    % combi is a struct
    combi.best=combination;%Protein combinations
    combi.area=area;%Area under curve
    combi.y_previous=y_previous;
    combi_store{k}=combi;
end
results_save.track=Track; %Track is the position of the C-Matrix
results_save.best = best;%Best combination 2 from 27
results_save.h = h; %Area under curve
results_save.y_previous = y_previous;
%scatter([1:size(trap_area,2)],trap_area)
end

