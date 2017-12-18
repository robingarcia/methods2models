%% Plot the best combinations
errordata=m2m_result.data_gen.errordata;
t_period=m2m_result.data_gen.t_period;
y_0=m2m_result.data_gen.y_0;
statenames=m2m_result.data_gen.statenames;
best_1=m2m_result.analysis.np_problem.BEST{1,1};
combination=best_1(:,1);

for i=[1,25]%1:size(combination,1)
   comb=combination(i);
   comb=[comb{:}];
   combo=combo_wanderlust(errordata(comb,:),t_period,y_0(comb),statenames(comb)); 
end