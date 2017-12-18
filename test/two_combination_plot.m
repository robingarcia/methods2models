%% Single wanderlust results of s
for i = 1:27
   figure(i)
   scatterhist(summary.s_Est(i,:),summary.Var_s(i,:))
end

%% Single wanderluts results of a
for i = 1:27
   figure(i)
   scatterhist(summary.a_Est(i,:),summary.Var_a(i,:))
end

%% Plot the best and the worst combination in one plot
plot(y(7,:),'DisplayName','APCP')
hold on
plot(y(12,:),'DisplayName','Cdh1')
hold on
plot(results_save.y_previous,'DisplayName','Cdh1+APCP')
hold on
plot(y(16,:),'DisplayName','Wee1i')
hold on
plot(y(24,:),'DisplayName','TFIi')
legend('show')

%% Plot the best and the worst combination in one plot (area)
