function [combi_store,best_comb] = M2M_area_temp(s_Exp,a_Exp,s_Var,a_Var,C,combi)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

n_cells=size(s_Exp,2);
% measurement_out=size(s_Exp,1);
binsize =0.1;
x = linspace(0,1,n_cells);%Normalized because from 0 to 1
% y = zeros(measurement_out,n_cells); % Functions of all species

   xwant = linspace(0,1,n_cells);% Range from 0 to 1
   x_wanderlust = normdata(a_Exp); %Expectation value (age)
   y_wanderlust = a_Var; %Variance (age)
   ywant = moving_average(x_wanderlust,y_wanderlust,xwant,binsize);
   y = ywant;%Wanted datapoints
   
   % Dual combinations
   if   C<=2
        combi = ([]);
        trap_area = zeros(1,size(C,1));
        for j = 1:size(C,1)
        y_1 = y(C(j,1),:);
        y_2 = y(C(j,2),:);
        y_previous = min(y_1,y_2);%Minimal value selected here
        trap_area(1,j) = trapz(x,y_previous);
        end
   % Smallest area under curve
   [~,Track] = sort(trap_area);% h= area under curve, Track = index of pos.

   combi_store=cell(1,size(trap_area,2));
        for k = 1:size(Track,2) 

    j=Track(k);
    disp(C(j,:))
    y_1 = y(C(j,1),:);
    y_2 = y(C(j,2),:);
    y_previous = min(y_1,y_2);
    combination=C(j,:);
    area=trap_area(j);
    % combi2 is a struct
    combi.best=combination;%Protein combinations
    combi.area=area;%Area under curve
    combi.y_previous=y_previous;
    combi_store{k}=combi;
        end
        
        
   % 2+n combinations
   else
       best_comb = cell(size(ic,1)-size(combi.best,2),5);%IMPORTANT
       bestcombo=combi.best;%IMPORTANT
       k=1;
       while k <= number_species

j = 1:size(1:27,1);% IMPORTANT
j = setdiff(j,bestcombo);%Exclude numbers that were already used
best_additional = zeros(1,size(ic,1));


    
    x_wand = normdata(a_Exp);% Discrete data points
    y_wand = a_Var;% Discrete data points
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

bestcombo = horzcat(best_comb{k,1},best_comb{k,2});%Update of bestcombo

k = k+1;
        end
   end
end

