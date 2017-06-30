model2008 = IQMmodel('model_toettcher2008.txt');

% simulate
tspan = [0,2000];

sim_out = IQMsimulate(model2008,tspan);

% states to plot
statenames = {'CycET','Cdc20A','CycA'};

% output bla
state_out{1} = {'CycE','TriE','TriE21'};
state_out{2} = {'Cdc20A'};
state_out{3} = {'CycA'};


% plot
for i=1:length(statenames)
    state_ind = zeros(size(sim_out.states));

    for j = 1:length(state_out(i))
       state_ind = state_ind | strcmp(sim_out.states, state_out{i}(j)); % vgl. Pos. und schreibe 1 falls wahr
    end
   % state_ind = strcmp(sim_out.states, statenames(i)); %Positionsermittlung mit logischem Output
   plot_values = sum(sim_out.statevalues(:,state_ind),2);
   plot(sim_out.time,plot_values,'LineWidth',3)
   hold on
   grid on
end
legend(statenames)
