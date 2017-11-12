function [best] = M2M_area_temp(y,best,y_update,k)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


   
   % Dual combinations
   if   isempty(best)
        x = linspace(0,1,size(y,2));
        z = 1:size(y,1); %Number of parameters
            C=nchoosek(z,2);% Two measurement outputs
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
   
        for k = 1:size(Track,1)%2) 
        best{1,k}(1,1)={1};                 %Round
        best{1,k}(:,2)={C(Track(k),:)};     %Combination
        best{1,k}(1,3)={trap_area(Track(k))};%Area
        end
        
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        
   % 2+n combinations
   else
       bestcombo=best{k,2};%IMPORTANT
%        bestcombo=[bestcombo{:}];%cell to double
j = 1:size(y,1)-1;%27;% IMPORTANT (size(y,2))!!!
j = setdiff(j,bestcombo);%Exclude numbers that were already used
best_additional = zeros(1,27);

    x = linspace(0,1,size(y,2));%Normalized because from 0 to 1
    
    % Find smallest area under curve
    for i = j
        best_additional(1,i) = trapz(x,y(i,:)-y_update);%Import ywant and y!
    end

best_additional(best_additional == 0) = NaN;%Replace 0 with NaN in order to avoid 0 is detected as smallest value.
[~,Track] = min(best_additional);
best(k+1,1)={k+1};%Round
best(k+1,2)={horzcat(bestcombo,Track)}; % Track is the new protein/new combination
% best(k+1,3)={area}; %best_additional(Track(1))
   end
end

