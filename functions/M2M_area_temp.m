function [best,y_previous] = M2M_area_temp(y,best)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


   
   % Dual combinations
   if   isempty(best)
        x = linspace(0,1,size(y,2));
        z = 1:size(y,1); %Number of parameters
            C=WChooseK(z,2);% Two measurement outputs
            best=cell(1,size(C,1));
            trap_area = zeros(1,size(C,1));
            for j = 1:size(C,1)
            y_1 = y(C(j,1),:);
            y_2 = y(C(j,2),:);
            y_previous = min(y_1,y_2);%Minimal value selected here
            trap_area(1,j) = trapz(x,y_previous);
            end
       
%         combi = ([]);
        
   % Smallest area under curve
   [~,Track] = sort(trap_area);% h= area under curve, Track = index of pos.
   
%    combi_store=cell(1,size(trap_area,2));
        for k = 1:size(Track,2) 
        best{1,k}(1,1)={k};                 %Round
        best{1,k}(:,2)={C(Track(k),:)};     %Combination
        best{1,k}(1,3)={trap_area(Track(k))};%Area
    j=Track(k);
%     disp(C(j,:))
    y_1 = y(C(j,1),:);
    y_2 = y(C(j,2),:);
    y_previous = min(y_1,y_2);
%     combination=C(j,:);
%     area=trap_area(j);
    % combi2 is a struct
%     combi.best=combination;%Protein combinations
%     combi.area=area;%Area under curve
%     combi.y_previous=y_previous;
%     combi_store{k}=combi;
        end
        
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        
   % 2+n combinations
   else
%        best_comb = cell(size(ic,1)-size(combi.best,2),5);%IMPORTANT
       bestcombo=best;%IMPORTANT
       bestcombo=[bestcombo{:}];
%        number_species = minus(size(ic,1),size(bestcombo,2));%GET INFO FROM WHERE?
       number_species = minus(27,size(bestcombo,2));%GET INFO FROM WHERE?

       k=1;
       while k <= number_species

j = 1:size(1:27,1);% IMPORTANT
j = setdiff(j,bestcombo);%Exclude numbers that were already used
best_additional = zeros(1,size(ic,1));


    
%     x_wand = normdata(a_Exp);% Discrete data points
%     y_wand = a_Var;% Discrete data points
%     ywant = moving_average(x_wand, y_wand, x, binsize);% Calculate new line

    x = linspace(0,1,size(y,2));%Normalized because from 0 to 1
    B = trapz(x,y);%Area under curve from new combination IMPORTANT? 10.10.17
    
    % Find smallest area under curve
    for i = j
        best_additional(1,i) = trapz(x,y(i,:)-ywant);%Import ywant and y!
    end

best_additional(best_additional == 0) = NaN;%Replace 0 with NaN in order to avoid 0 is detected as smallest value.
[area,Track] = min(best_additional);
best(1,1)={k+1};
best(1,2)=horzcat(bestcombo,Track); % Track is the new protein
best(1,3)={area};
k=k+1;
% best_comb{k,1} = bestcombo;% Best combination
% best_comb{k,2} = Track;% New recommended protein
% best_comb{k,3} = area; % Area under the new curve (new combination)
% best_comb{k,4} = best_additional;
% best_comb{k,5} = B;%Area of previous combination

% bestcombo = horzcat(best_comb{k,1},best_comb{k,2});%Update of bestcombo

% k = k+1;
        end
   end
end

