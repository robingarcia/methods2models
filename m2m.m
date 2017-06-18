function [results] = m2m
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
profile on
addpath(genpath('~/methods2models'));
load('~/methods2models/datasets/toettcher_statenames.mat');

%% Datageneration ---------------------------------------------------------
[ic,~,errordata,y_0,t_period,~,~] = data_generation;%(tmax,tF,lb,N,sig,snapshots);

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

% [var_age,z] = sort(summary.area_A);
% for j = 2:size(ic,1)
%     
%     
% end


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

binsize =0.2;
for i = 1:size(ic,1) % For all 27 species
   xwant = linspace(0,1,size(results(1).a_Est(i,:),2));
   x = normdata(results(1).a_Est(i,:));
   y = results(1).Var_a(i,:);
   ywant = moving_average(x,y,xwant,binsize);
   f{i} = griddedInterpolant(xwant,ywant,'cubic');%Linear?
%    figure(i)
%    scatter(x,y)
%    hold on
%    plot(xwant,ywant,'x');
%    %legend(statenames(i));
%    hold on
%    plot((linspace(0,1,size(results(1).a_Est(i,:),2))),f{i}((linspace(0,1,size(results(1).a_Est(i,:),2)))),'g');
%    hold on
%    %legend(statenames([1:27]));
%    xlabel('E(age)')        % x-axis label
%    ylabel('Variance(age)') % y-axis label
end
%% New datapoints
x = linspace(0,1,size(errordata,2));
y = zeros(size(ic,1),size(errordata,2));
Q = zeros(1,size(ic,1));
for i = 1:size(ic,1) 
    y(i,:) = f{i}(x);
%     Q(1,i) = trapz(x,y(i,:));
    Q(1,i) = trapz(y(i,:));
%     figure(i)
%     plot(x,y(i,:))
%     hold on
end
%% ---- New calculated data points
x = 1:size(ic,1);
x_linspace = linspace(0,1,size(errordata,2));

for x = x
    datapoint_set(x,:) = f{x}(x_linspace);
end
%% --tr5
x = 1:size(ic,1);
for i = 2%:2%size(ic,1)
    C = WChooseK(x,i);
    trap_area = zeros(1,size(C,1));
    for j = 1:size(C,1)
        combination = C(j,:);
        %y_1 = f{C(j,1)}(x_linspace);
        %y_2 = f{C(j,2)}(x_linspace);
        y_1 = y(C(j,1),:);
        y_2 = y(C(j,2),:);
        y_3 = bsxfun(@min, y_1,y_2);
        %area_1 = trapz(y_1);
        %area_2 = trapz(y_2);
        trap_area(1,j) = trapz(y_3);
    end
end
[h,Track] = min(trap_area);
best = C(Track,:);

%% %% Second round
 %row=find(C(:) == [best]);
% 
for i = 3%:size(ic,1)
    C = WChooseK(x,i);
    row=find(C(:) == [best]);
    trap_area = zeros(1,size(C,1));
    for j = 1:size(C,1)
        combination = C(j,:); %Select only the best combinations!
        %y_1 = f{C(j,1)}(x_linspace);
        %y_2 = f{C(j,2)}(x_linspace);
        y_1 = y(C(j,1),:);
        y_2 = y(C(j,2),:);
        y_3 = bsxfun(@min, y_1,y_2);
        %area_1 = trapz(y_1);
        %area_2 = trapz(y_2);
        trap_area(1,j) = trapz(y_3);
    end
end
%[h,T] = min(trap_area);
%best = C(T,:)

%==========================================================================
% MATLAB FORUM!
A = [1 5 6; 5 4 3; 9 4 2];
want = [4 5];

szA = size(A,1);
idx = false(szA,1);

for ii = 1:szA
  idx(ii) = all(ismember(want,A(ii,:)));
end
find(idx)
%==========================================================================
%% Plots
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
[min_area,z]=min(b_all)

% for z
%     
% end
end