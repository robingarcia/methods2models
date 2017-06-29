%% M2M_plots
ic_default = model_toettcher2008MEX;
ic_default= M2M_purge(ic_default);
ic_rand = ic;
% Initial conditions
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

% Statevalues
plot(tF, original_statevalues([1 2 3 5 6 7],:));

