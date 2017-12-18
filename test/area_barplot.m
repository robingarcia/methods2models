%% Plot the area results as barplot
% Preallocation
% combi_all=zeros(
names=m2m_result.data_gen.statenames;
for i=1:2
combi=m2m_result.analysis.np_problem.BEST{1,i}(1,1);    
bestorder=m2m_result.analysis.np_problem.BEST{1,i}(:,2);
bestarea=m2m_result.analysis.np_problem.BEST{1,i}(:,5);
combi=[combi{:}];
bestorder=[bestorder{:}];
bestarea=[bestarea{:}];

combi_all(i,:)=combi;
area_all(i,:)=bestarea;
order_all(i,:)=bestorder;
end
area_all=area_all';
order_all=order_all';

%% plot it
figure(1)
label_name=names(order_all(:,1));
bar_area=bar(area_all);
legend(num2str(combi_all));
% set(gca,'xticklabel',label_name);
set(gca,'XTick',1:length(label_name),'XTickLabel',label_name);

%% Subplot 2D-bar
figure(3)
label_name=names(order_all(:,1));
ax1=subplot(2,1,1);
bar(ax1,area_all(:,1))
legend(num2str(combi_all(1,:)));
set(gca,'XTick',1:length(label_name),'XTickLabel',label_name);

label_name=names(order_all(:,2));
ax2=subplot(2,1,2);
bar(ax2,area_all(:,2))
legend(num2str(combi_all(2,:)));
set(gca,'XTick',1:length(label_name),'XTickLabel',label_name);
%% 3D barplot
figure(2)
bar3_area=bar3(area_all);
legend(num2str(combi_all));
set(gca,'YTick',1:length(label_name),'YTickLabel',label_name);