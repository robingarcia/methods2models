 function fh = PlotERAVariance(data,ERA,opts)

%% Function to plot the age variance obtained from ERA datasets

if opts.doplots
	% age variance
rect = [20 20 800 600];
fh(1) = figure('Color','w','Position',rect);
subplot(1,2,1)
% scatter(data(:,opts.PathIndex(1)),data(:,opts.PathIndex(2)),8,ERA.a_single_cell_Variance)
scatter(data(:,opts.PathIndex(1)),(1:size(data,1)),8,ERA.a_single_cell_Variance)
colormap('copper')
set(gca,'CLim',[0,prctile(ERA.a_single_cell_Variance,95)*1.2])
shading interp
xlabel(opts.Ynames{opts.PathIndex(1)})
% ylabel(opts.Ynames{opts.PathIndex(2)})
subplot(1,2,2)
scatter([ERA.a_single_cell_Expectation{:}],ERA.a_single_cell_Variance,8,ERA.a_single_cell_Variance)
set(gca,'CLim',[0,prctile(ERA.a_single_cell_Variance,95)*1.2])
colorbar
xlabel('E(a)')
ylabel('Var(a)')
set(gca,'YLim',[0,prctile(ERA.a_single_cell_Variance,95)*1.2])
combination=num2str(opts.PathIndex);
title = ['Variance in a of single cells', combination];
suptitle(title)

	% s variance
rect = [20 20 800 600];
fh(2) = figure('Color','w','Position',rect);
subplot(1,2,1)
% scatter(data(:,opts.PathIndex(1)),data(:,opts.PathIndex(2)),8,ERA.s_single_cell_Variance)
scatter(data(:,opts.PathIndex(1)),(1:size(data,1)),8,ERA.s_single_cell_Variance)

colormap('copper')
set(gca,'CLim',[0,prctile(ERA.s_single_cell_Variance,95)*1.2])
shading interp
xlabel(opts.Ynames{opts.PathIndex(1)})
% ylabel(opts.Ynames{opts.PathIndex(2)})
subplot(1,2,2)
scatter([ERA.s_single_cell_Expectation{:}],ERA.s_single_cell_Variance,8,ERA.s_single_cell_Variance)
set(gca,'CLim',[0,prctile(ERA.s_single_cell_Variance,95)*1.2])
colorbar
xlabel('E(s)')
ylabel('Var(s)')
set(gca,'YLim',[0,prctile(ERA.s_single_cell_Variance,95)*1.2])
combination=num2str(opts.PathIndex);
title = ['Variance in s of single cells', combination];
suptitle(title)
end
end