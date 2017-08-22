%% Plot DNA Synthesis
yyaxis left
area(DNA(:,1))
yyaxis right
plot(random_statevalues{1,1}(:,12))

%%
plot3k({mydata(1,:),mydata(12,:),mydata(32,:)})
hold on
plot3k({errordata(1,:),errordata(12,:),errordata(32,:)})