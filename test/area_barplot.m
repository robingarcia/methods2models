%% Plot the area results as barplot
for i=1
bestorder=m2m_result.analysis.np_problem.BEST{1,1}(:,2);
bestarea=m2m_result.analysis.np_problem.BEST{1,1}(:,5);
bestorder=[bestorder{:}];
bestarea=[bestarea{:}];

area_all(i,:)=bestarea;
end
area_all=area_all';