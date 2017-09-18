%% Plot DNA Synthesis
yyaxis left
area(DNA(:,1))
yyaxis right
plot(random_statevalues{1,1}(:,12))

%% 3D Plot
plot3k({mydata(7,:),mydata(11,:),mydata(32,:)})
hold on
plot3k({errordata(7,:),errordata(11,:),errordata(32,:)})

%% 3D subplot

