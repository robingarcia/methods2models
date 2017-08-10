function [best_comb] = M2Marea(results_save,errordata,y,ic,y_0,t_period,statenames)
% This function calculates the area unter the curve 
% 
% 
% [Syntax]
% [best_comb] = M2Marea(results_save,errordata,y,f,ic,y_0,t_period,statenames)
% 
% [INPUT]
% results_save:
% errordata:
% y:                number: Datapoints
% f:                cell:   Function handles
% ic:               number: Initial conditions
% y_0:              number: Start of the cell cylce
% t_period:         number: Cell cycle period
% statenames:       cell:   Names of the species
% 
% [OUTPUT]
% best_comb:        struct: Contains the results for all combinations
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
k=1;
binsize = 0.1;

best_comb = cell(size(ic,1)-2,5);
y_wand = results_save.y_previous;
bestcombo = results_save.best;
number_species = minus(size(ic,1),size(bestcombo,2));
x = linspace(0,1,size(y_wand,2));
while k < number_species
j = 1:size(ic,1);
j = setdiff(j,bestcombo);%Exclude numbers that were already used
best_additional = zeros(1,size(ic,2));


    % Wanderlust recalculate
    combo = combo_wanderlust(errordata(bestcombo,:),t_period,y_0(bestcombo),statenames);
    x_wand = normdata(combo.a_E);
    y_wand = combo.Variance_A;
    ywant = moving_average(x_wand, y_wand, x, binsize);

    B = trapz(x,ywant);
    
    
    for i = j
        
        best_additional(1,i) = trapz(x,y(i,:)-ywant);
        
    end

best_additional(best_additional == 0) = NaN;
[area,T] = min(best_additional);
best_comb{k,1} = bestcombo;% Best combination
best_comb{k,2} = T;%
best_comb{k,3} = area;
best_comb{k,4} = best_additional;
best_comb{k,5} = B;
bestcombo = horzcat(best_comb{k,1},best_comb{k,2});%remove sort
k = k+1;
disp(k)
end
end

