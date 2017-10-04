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

best_comb = cell(size(ic,1)-size(results_save.best,2),5);
y_prev_func = results_save.y_previous;% New function from previous combination
% y_previous_area = results_save.area;% New function from previous combination
bestcombo = results_save.best;
number_species = minus(size(ic,1),size(bestcombo,2));
x = linspace(0,1,size(y_prev_func,2));%Normalized because from 0 to 1
% old=combi_store{l}.best;
while k <= number_species
disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
disp_k=[num2str(k),' from ',num2str(number_species),' possible species'];
disp(disp_k)
disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
    time_spec=tic;
j = 1:size(ic,1);
j = setdiff(j,bestcombo);%Exclude numbers that were already used
best_additional = zeros(1,size(ic,1));


    % Wanderlust recalculate the new combination (Time consuming step)
    combo_time=tic;
    combo = combo_wanderlust(errordata(bestcombo,:),t_period,y_0(bestcombo),statenames);%Wanderlust function?
    toc(combo_time)
    x_wand = normdata(combo.a_E);% Discrete data points
    y_wand = combo.Variance_A;% Discrete data points
    ywant = moving_average(x_wand, y_wand, x, binsize);% Calculate new line

    B = trapz(x,ywant);%Area under curve from new combination
    
    % Find smallest area under curve
    for i = j
        best_additional(1,i) = trapz(x,y(i,:)-ywant);%Substraction???
%         best_additional(1,i) = trapz(x,min(ywant,y(i,:)));
    end

best_additional(best_additional == 0) = NaN;%Replace 0 with NaN in order to avoid 0 is detected as smallest value.
[area,Track] = min(best_additional);
best_comb{k,1} = bestcombo;% Best combination
best_comb{k,2} = Track;% New recommended protein
best_comb{k,3} = area; % Area under the new curve (new combination)
best_comb{k,4} = best_additional;
best_comb{k,5} = B;%Area of previous combination
% bestcombo = horzcat(best_comb{k,1},best_comb{k,2});%Update of bestcombo
% k = k+1;
% toc(time_spec)

% clc
disp(['+++',num2str(linspace(k,k,10)),'+++'])
disp(['Old combination:>>' num2str(bestcombo)])
disp(['Add:',num2str(Track)])
bestcombo = horzcat(best_comb{k,1},best_comb{k,2});%Update of bestcombo
% old=horzcat(old,Track);
disp(['New combination:<<' num2str(bestcombo)])
disp(['Time:',num2str(toc(time_spec))])
disp(['+++',num2str(linspace(k,k,10)),'+++'])
k = k+1;
toc(time_spec)
end
end

