%% M2M_plots
ic_default = model_toettcher2008MEX;
% ic_default= M2M_purge(ic_default);
ic_rand = M2M_lognrnd_ic(N,ic_default);
%% Initial conditions
for i =[1 2 3 5 6 7]%1:27%size(ic,1)
    figure(i)
    axis([0 size(ic_rand,2) 0 2])
    plot_x = linspace(0,size(ic_rand,2),N);%   zeros(size(ic,2));
    plot_default = zeros(1,size(ic_rand,2));
    plot_start = zeros(1,size(ic_rand,2));
    plot_default(:)=ic_default(i);
    plot_start(:)=y_0(i);
    hold on
    bar(sort(ic_rand(i,:),2,'descend'),'DisplayName','Random IC');
    axis([0 size(ic_rand,2) 0 2])
    hold on
    def = plot(plot_x,plot_default(1,:),'LineWidth',3,'DisplayName','Default IC');
tmp = abs(sort(ic_rand(i,:),2,'descend')-ic_default(i)); %Find closest value
[~, idx] = min(tmp);%Find closest value
bar(idx,ic_default(i),'g'); %Find closest value
    def.Color = [0 1 0];
    axis([0 size(ic_rand,2) 0 2])
    hold on
    pstart = plot(plot_x,plot_start(1,:),'LineWidth',3,'DisplayName','Conc. at start');
tmp = abs(sort(ic_rand(i,:),2,'descend')-y_0(i));
[~, idx] = min(tmp);
bar(idx,y_0(i),'r');
    axis([0 size(ic_rand,2) 0 2])
    pstart.Color = [1 0 0];
    title('Initial conditions')
end
title('Initial conditions')
%% IC baseline
size(ic,1);
for i = 1:size(ic,1)
    figure(i)
b=bar(rndmic(i,:));
b(1).BaseValue = ic(i);
b(1).BaseLine.LineStyle = ':';
b(1).BaseLine.Color = 'red';
b(1).BaseLine.LineWidth = 2;
end
%% Histogram
for i = [1 2 3 5 6 7]
figure(i)
% IC_hist=histogram(ic_rand(7,:),'BinWidth',0.1);
IC_histfit=histfit(ic_rand(7,:),round(N/8),'lognormal');
IC_histfit(1).FaceColor = [0.8 0.8 1];
ic_xdata = IC_histfit(1).XData;
ic_ydata = IC_histfit(1).YData;
tmp = abs(ic_xdata-ic_default(i));
[~,idx]=min(tmp);
ic_ydata_default = ic_ydata(idx);
xlabel('Initial conditions')
ylabel('Frequency')
title('Distribution of the randomized initial conditions')
hold on
% bar(ic_default(7),40,'r','BarWidth',IC_hist.BinWidth);
bar(ic_default(i),ic_ydata_default,'g','BarWidth',IC_histfit(1).BarWidth/10);
end
%% Statevalues
for i = 1:20%N
figure(i)
for j = [1 2 3 5 6 7]
h1(1)=plot(tF, random_statevalues{1,i}(:,j),'LineWidth',2,'LineStyle','--');
hold on
h1(2)=plot(tF, original_statevalues(j,:),'LineWidth',2);
ColOrd = get(gca,'ColorOrder');
set(h1(1),'color',ColOrd(j,:))
set(h1(2),'color',ColOrd(j,:))
% hold on
% legend(statenames(j));
% hold on
end
axis([960 tF(end) 0 2])
grid on
xlabel('Time (h)');
ylabel('Concentration (au)');
title('Statevalues of one cell');
end
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
%% Random statevalues and limit cycle
for j = 1:31
    figure(j)
for i = 1:N
    plot(random_statevalues{1,i}(:,j),'r','LineWidth',2)
    hold on
    plot(original_statevalues(j,:),'b','LineWidth',2)
    hold on
    scatter(0,ic(j,1),'b','filled')
    hold on
    scatter(0,rndmic(1,1),'r','filled')
end
end

%% Mydata + errordata + DNA
for i = [1 2 3 5 6 7]%1:31%*N
%     figure(i)
% [X,I] = sort(time);
data=mydata(i,:);
data = sort(data);
data = normdata(data);
h1(1)=plot(data);
hold on
error=errordata(i,:);
error = sort(error);
error = normdata(error);
h1(2)=plot(error,'LineStyle','--');
hold on
ColOrd = get(gca,'ColorOrder');
set(h1(1),'color',ColOrd(i,:))
set(h1(2),'color',ColOrd(i,:))
% scatter(X,mydata(i,:))
end
dna = mydata(32,:);
dna = sort(dna);
dna = normdata(dna);
plot_dna = plot(dna,'k','LineWidth',5);

%% Mydata + errordata 3D plot

scatter3(time,errordata(1,:),errordata(32,:))