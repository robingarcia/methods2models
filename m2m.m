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
for j = 1:2%size(ic,1)%[2,27]%1%:2
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


% %% Pure the results
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
% --------------------------------------------------------------------------
% f = cell(1,size(ic,1));
% for i = 1:27
%    x = results(1).a_Est(i,:);
%    y = results(1).Var_a(i,:);
% %    x_I = 0:t_period(1,1);
% %    f{i} = interp1(x,y,x_I);
%    f{i} = griddedInterpolant(x,y,'spline');%Linear?
%    %figure(i)
%    %plot(x,y,'o');
%    %legend(statenames(i));
% %    hold on
% %    plot(f{1,i}.GridVectors{1,1},f{1,i}.Values);
% %    hold on
% %    legend(statenames([1:27]));
% %    xlabel('E(age)')        % x-axis label
% %    ylabel('Variance(age)') % y-axis label
% end

for i = 1:27
    x_p = (-400:4000);
    y_p = f{i}(x_p);
    %figure(i)
    plot(x_p,y_p)
%     plot(results(2).a_all_cells(i,:))
    hold on
end
% for i = 2;%i = size(results,1)
%     results(i).comb{1,:}
% end


% for i = 1:size(results(2).comb,1)
%     results(2).comb{i,1};
%     f(i) = bsxfun(@min,(results(1).Var_a(results(2).comb{i,1}(1))),(results(1).Var_a(results(2).comb{i,1}(2))));
% end

% for j = 2:size(ic,1)
%     for i = 1:size(WChooseK(1:size(ic,1),j),1)
%        tic
%        [~,deed,~] = Cmatrix(i,j,size(errordata,1),errordata)
%        toc
%     end
% end
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