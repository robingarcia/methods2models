function [results] = m2m
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
profile on
addpath(genpath('~/methods2models'));
load('~/methods2models/datasets/toettcher_statenames.mat');

%% Datageneration ---------------------------------------------------------
[ic,~,errordata,y_0,t_period,~,~,time] = data_generation;%(tmax,tF,lb,N,sig,snapshots);

%% Purge datasets
[errordata,~,nzero] = M2M_purge(errordata);
[ic, ~] = M2M_purge(ic);
[y_0, ~] = M2M_purge(y_0);
statenames = statenames(nzero);
%% Wanderlust analysis ----------------------------------------------------
% [results]=wanderlust_analysis(errordata,ic,y_0,t_period,statenames);
[w_data,w_path] = pre_wanderlust(errordata,ic,y_0,statenames,t_period);

%% Pre computation --------------------------------------------------------
Summary=cell(1,size(ic,1));%Preallocation
for j = [1 2 27]%size(ic,1)%[2,27]%1%:2
    tic
summary = M2M_combinatorics(w_data,w_path,t_period,ic,errordata,statenames,j);
Summary{j} = summary;
toc
end
results = cat(1,Summary{:});


% %% Purge the results
% tic
% for i = 1:size(results,1)
% %     results(i).s_E = M2M_purge(results(i).s_E);
% %     results(i).a_E = M2M_purge(results(i).a_E);
% %     results(i).Variance_S = M2M_purge(results(i).Variance_S);
% %     results(i).Variance_A = M2M_purge(results(i).Variance_A);
%     results(i).area_S = M2M_purge(results(i).area_S);
%     results(i).area_A = M2M_purge(results(i).area_A);
%     results(i).comb = results(i).comb(~cellfun('isempty',results(i).comb));
% %     results(i).combn = results(i).combn(~cellfun('isempty',results(i).combn));
% %     results(i).combinations = results(i).combinations(~cellfun('isempty',results(i).combinations));
% end
% toc

%% Combinations -----------------------------------------------------------
% for i = 1:27
%     %figure(i)
%     for    j = 1:2
%     scatter(normdata(results(j).a_Est(i,:)),results(j).Var_a(i,:));
%     hold on
% %     scatter((results(j).a_Est(i,:)-min(results(j).a_Est(i,:))./range(results(j).a_Est(i,:))),results(j).Var_a(i,:));
% %     hold on
%     end
% end
%--------------------------------------------------------------------------
%==========================================================================
% % --------------------------------------------------------------------------
f = cell(1,size(ic,1));

binsize =0.1;
for i = 1:size(ic,1) % For all 27 species
   xwant = linspace(0,1,size(results(1).a_Est(i,:),2));
   x = normdata(results(1).a_Est(i,:));
   y = results(1).Var_a(i,:);
   ywant = moving_average(x,y,xwant,binsize);
   
%    Q(1,i) = trapz(xwant,ywant);%Calculate the area
   f{i} = griddedInterpolant(xwant,ywant,'cubic');%Linear?
%    figure(i)
%    scatter(x,y)
%    hold on
%    plot(xwant,ywant,'x');
%    %legend(statenames(i));
%    hold on
%    plot(xwant,f{i}(xwant),'g');
%    hold on
%    %legend(statenames([1:27]));
%    xlabel('E(age)')        % x-axis label
%    ylabel('Variance(age)') % y-axis label
end
%% New datapoints
x = linspace(0,1,size(errordata,2));
y = zeros(size(ic,1),size(errordata,2));% Functions of all species
% Q = zeros(1,size(ic,1)); %Area under the curve? 
for i = 1:size(ic,1) 
    y(i,:) = f{i}(x);%Calculate the function
%     Q(1,i) = trapz(x,y(i,:));
%     Q(1,i) = trapz(x,y(i,:));%Calculate the area
%     figure(i)
%     plot(x,y(i,:))
%     hold on
end
% %% ---- New calculated data points
% x = 1:size(ic,1);
% x_linspace = linspace(0,1,size(errordata,2));
% 
% for x = x
%     datapoint_set(x,:) = f{x}(x_linspace);
% end
%% -- 2 combinations
%results_save = cell(4,27);
x = normdata(linspace(0,1,size(errordata,2)));
results_save = ([]);
z = 1:size(ic,1);
for i = 2%:2%size(ic,1)
    %results_save{1,i} = i; % Number of simultaneous measurements
    results_save.i = i;
    C = WChooseK(z,i);
    trap_area = zeros(1,size(C,1));
    for j = 1:size(C,1)
        %combination = C(j,:);
        %y_1 = f{C(j,1)}(x_linspace);
        %y_2 = f{C(j,2)}(x_linspace);
        y_1 = y(C(j,1),:);
        y_2 = y(C(j,2),:);
        y_previous = min(y_1,y_2);%bsxfun(@min, y_1,y_2); %min instead of bsxfun!!!
        %area_1 = trapz(y_1);
        %area_2 = trapz(y_2);
        trap_area(1,j) = trapz(x,y_previous);
    end
end
[h,Track] = min(trap_area);
best = C(Track,:);
for j = Track
    y_1 = y(C(j,1),:);
    y_2 = y(C(j,2),:);
    y_previous = min(y_1,y_2);%bsxfun(@min, y_1,y_2); %min instead of bsxfun!!!
end
% results_save{2,i} = best;
% results_save{3,i} = h;
% results_save{4,i} = y_previous;
results_save.best = best;
results_save.h = h; %Area under curve
results_save.y_previous = y_previous;
Results_save{i} = results_save;

%% -- New approach ========================================================
k=1;
disp(k)
binsize =0.1;
% f_star = cell(1,1);
best_comb = ([]);%cell(size(ic,1),3);
best_additional = zeros(1,27);
bestcombo = results_save.best;
number_species = size(ic,1);
area = results_save.h; %Area under curve
f_combo = results_save.y_previous;
% best_additional = zeros(size(ic,1),size(y_previous,2));
while k < number_species
%     if k == 1 %initial run
%         bestcombo = results_save.best;
%     combo = combo_wanderlust(errordata(bestcombo,:),t_period,y_0(bestcombo),statenames);
%     xwant = linspace(0,1,size(combo.a_E(1,:),2));
%     x = normdata(combo.a_E(1,:));
%     %y = combo.Variance_A(1,:);
%     ywant = moving_average(x,y,xwant,binsize);
%     f_star = griddedInterpolant(xwant,f_combo,'cubic');
    

%     else
%     combo = combo_wanderlust(errordata(bestcombo,:),t_period,y_0(bestcombo),statenames);
%     xwant = linspace(0,1,size(combo.a_E(1,:),2));
    xwant = linspace(0,1,size(y_previous,2));

%     x = normdata(combo.a_E(1,:));
%     y = combo.Variance_A(1,:);
%     ywant = moving_average(x,y,xwant,binsize);
    f_star = griddedInterpolant(xwant,f_combo,'cubic');
%     f_star = griddedInterpolant(xwant,ywant,'cubic');
    

%     end
    
j = 1:size(ic,1);
j=j(~ismember(j,bestcombo));%Exclude numbers that were already used
    
    for i=j% = 1:size(ic,1)
        no_1 = trapz(xwant,f_star(xwant));
        no_2 = trapz(xwant,f{i}(xwant));
        no_3 = no_2-no_1;
%     best_additional(1,i) = trapz(xwant,bsxfun(@minus,f{i}(xwant),f_star(xwant)));%Error!
%     best_additional(i) = min(trapz(xwant,f{i}(xwant)-f_star(xwant)));%Error!
best_additional(1,i) = no_3; %trapz(xwant,no_2 - no_1);%Error
    end
    best_additional(best_additional == 0) = NaN;%Exclude 0 as minimal value
    [area,T] = min(best_additional);%It is nonsens to extract T!!!
    disp(T);
    %best_additional = f{T}(xwant)-f_star(xwant);%Check T (matrix dimension)
    %end
    
    %----------------------------------------------------------------------
    best_comb.bestcombo = bestcombo;%{k,1} = bestcombo;
    best_comb.T = T;%{k,2} = T;%
    best_comb.area = area;%{k,3} = area; 
%   k = k+1;
    %f_combo = best_additional;%(T,:);
    bestcombo = sort(horzcat(best_comb{k,1},best_comb{k,2}));
    k = k+1;
    disp(k)
end
%==========================================================================

%% New approach 2 (it works without any error so far)
k=1;
binsize = 0.1;

best_comb = cell(size(ic,1)-2,4);
f_combo = results_save.y_previous;
bestcombo = results_save.best;
number_species = minus(size(ic,1),size(bestcombo,2));
x = linspace(0,1,size(f_combo,2));
while k < number_species
j = 1:size(ic,1);
j = setdiff(j,bestcombo);%Exclude numbers that were already used
best_additional = zeros(1,size(ic,2));
if k == 1
for i = j
   best_additional(1,i) = trapz(x,minus(f{i}(x),f_combo));
end

else
    % Wanderlust recalculate
    combo = combo_wanderlust(errordata(bestcombo,:),t_period,y_0(bestcombo),statenames);
    x_wand = normdata(combo.a_E);
    y_wand = combo.Variance_A;
    ywant = moving_average(x_wand, y_wand, x, binsize);
    f_star = griddedInterpolant(x,ywant,'cubic');
    for i = j
   best_additional(1,i) = trapz(x,minus(f{i}(x),ywant));%f_star(x)));
%    best_additional(1,i) = trapz(x,minus(f{T}(x),f{i}(x)));
    end
end


best_additional(best_additional == 0) = NaN;
[area,T] = min(best_additional);
best_comb{k,1} = bestcombo;
best_comb{k,2} = T;%
best_comb{k,3} = area;
best_comb{k,4} = best_additional;
bestcombo = horzcat(best_comb{k,1},best_comb{k,2});%remove sort
k = k+1;
disp(k)
end

for i = 1:24
    B(i,1) = best_comb{i,3};
    D(i,1) = best_comb{i,2};
end

for i = 1:24
    figure(i)
    hold on
    plot(y_previous,'LineWidth',5)
    hold on
    plot(f{D(i,1)}(x));
    hold on
    plot(f{D(i+1,1)}(x));
    lgd = legend('7,12',num2str(D(i,1)),num2str(D(i+1,1)));
    title(lgd,'Combination')
    xlabel('E(age)')        % x-axis label
    ylabel('Variance(age)') % y-axis label
end

for i = 1:24
   figure(i)
   hold on
   for j = best_comb{i,1}
   plot(f{j}(x));
   hold on
   end
   plot(f{D(i,1)}(x));
end
%==========================================================================
%% %% Second round with 2+n combinations
 %row=find(C(:) == [best]);
x_linspace = linspace(0,1,size(errordata,2));
z = 1:size(ic,1);
trap_area = 0;
for i = 3:size(ic,1)
    tic
    disp(i)
    %results_save{1,i} = i;% Number of simultaneous measurements
    results_save.i = i;
    C = WChooseK(z,i); %Calculate new combinations
%     szC = size(C,1);
%     idx = false(szC,1);
%     for ii = 1:szC
%         idx(ii) = all(ismember(results_save{2,i-1},C(ii,:)));
%     end
%     find_rows = find(idx);%Which combinations contain the previous combination?
    %trap_area = zeros(1,size(C,1));
%     for j = 1:size(find_rows,1)
        %combination = C(j,:); %Select only the best combinations!
        old_combination = Results_save{1,i-1}.best;%results_save{2,i-1};
        new_combination = 1:size(ic,1); %C(find_rows(j,1),:);
        use_combination = setdiff(new_combination,old_combination);
        trap_area = zeros(1,size(use_combination,2));
        y_new = zeros(size(use_combination,2),size(x_linspace,2));%??
        y_previous = Results_save{1,i-1}.y_previous; %results_save{4,i-1};
        for use_combination = use_combination
        y_actual = f{use_combination}(x_linspace);
        %y_previous = results_save{4,i-1};
        %y_actual = y(C(find_rows(j,:),:);% What do we need here? 
        y_new(use_combination,:) = min(y_actual,y_previous);% bsxfun(@min, y_actual,y_previous);
        %area_1 = trapz(y_1);
        %area_2 = trapz(y_2);
        trap_area(1,use_combination) = trapz(x_linspace,y_new(use_combination,:));
        end
%     end
trap_area(trap_area == 0) = NaN;
[h,T] = min(trap_area);%min has a bug!!!?
%best = C(T,:);%also extract previous numbers here (LATER!!)
best_prev = Results_save{1,i-1}.best;%results_save{2,i-1};
best = sort(horzcat(best_prev,T));% n best (but here n+n best)!!!

%     szC = size(C,1);
%     idx = false(szC,1);
%     for ii = 1:szC
%         idx(ii) = all(ismember(best,C(ii,:)));
%     end
%     find_rows = find(idx);%Which combinations contain the previous combination?

% results_save{2,i} = best;
% results_save{3,i} = h;
% results_save{4,i} = y_new(T,:);
y_new(T,:) = y_previous;
results_save.best = best;
results_save.h = h;
% results_save.y_new = y_new(T,:);
results_save.y_previous = y_previous;%(T,:);
Results_save{i} = results_save;
toc
% if Results_save{i-1}.h <= Results_save{i}.h %results_save{3,i-1} <= results_save{3,i}
% 
%     break
%     
% end
end
Result_all = cat(1,Results_save{:});

for i = 1:size(Result_all,1)
    H(1,i) = Result_all(i).h;
    
end
bar(H);
%% 2 Plots
b_area = zeros(1,size(ic,1));
B_area = cell(1,size(results,1));
%result_all = cat(1,sum_A(:).area_A); <-- I DID IT !!! \o/
%name_all = cat(1,results(:).combn); < -- IT WORKS !!!
%result_combn = categorical(result_combn);
%barh(result_combn,result_areaA)
% bar(result_areaA)
% set(gca,'XTickLabel',result_combn)
%profile viewer
for j = 1:size(results,1)
for i = 1:size(results(j).a_all_cells(:,1),1)
    b_area(1,i) = (sum(results(j).a_all_cells(i,:)));
   %Var_E_plot(results,i);
%    scatter([results.a_Est(i,:)],results.Var_a(i,:),8,results.a_Est(i,:))
%    hold on
% set(gca,'CLim',[0,prctile(results.a_Est(i,:),95)*1.2])
% colorbar
% xlabel('E(a)')
% ylabel('Var(a)')
%set(gca,'YLim',[0,prctile(results.Var_a(i,:),95)*1.2])
end
B_area{j} = b_area;
end
b_all = horzcat(B_area{1,1},B_area{1,2});
bar(b_all);
[min_area,z]=min(b_all);

% for z
%     
% end
end