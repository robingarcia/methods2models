%% M2M_plots
ic_default = model_toettcher2008MEX;
ic_default= M2M_purge(ic_default);
ic_rand = ic;
%% Initial conditions
for i =[1 2 3 5 6 7]%1:27%size(ic,1)
    figure(i)
    axis([0 size(ic,2) 0 2])
    plot_x = linspace(0,size(ic,2),1000);%   zeros(size(ic,2));
    plot_default = zeros(size(ic,2));
    plot_start = zeros(size(ic,2));
    plot_default(:)=ic_default(i);
    plot_start(:)=y_0(i);
    hold on
    bar(sort(ic_rand(i,:),2,'descend'),'DisplayName','Random IC');
    axis([0 size(ic,2) 0 2])
    hold on
    def = plot(plot_x,plot_default(1,:),'LineWidth',3,'DisplayName','Default IC');
    def.Color = [0 1 0];
    axis([0 size(ic,2) 0 2])
    hold on
    pstart = plot(plot_x,plot_start(1,:),'LineWidth',3,'DisplayName','Conc. at start');
    axis([0 size(ic,2) 0 2])
    pstart.Color = [1 0 0];
    title('Initial conditions')
end
title('Initial conditions')

%% Statevalues
plot(tF, original_statevalues([1 2 3 5 6 7],:),'LineWidth',3);
axis([1900 2000 0 2])
grid on
findpeaks(original_statevalues(2,:))


%% Skript Karsten
model2008 = IQMmodel('model_toettcher2008.txt');

% simulate
tspan = [0,100];

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
   title('Original statevalues');
end
legend(statenames)
%% Random statevalues
for j = 1%:31
    figure(j)
for i = 1%:5%N
    plot(random_statevalues{1,i}(:,j),'r','LineWidth',2)
    hold on
    plot(original_statevalues(1,:),'b','LineWidth',2)
    hold on
    scatter(0,ic(j,1),'b','filled')
    hold on
    scatter(0,rndmic(1,1),'r','filled')
end
end