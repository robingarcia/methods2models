function [fh] = M2M_triple(data,ERA,opts,combination,statenames,G)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% rect = [20 20 800 600];
% fh(1) = figure('Color','w','Position',rect);

%Density plot
% subplot(1,3,1)
figure(1)
[~,dens,X,Y] = kde2d(data);

	pcolor(X,Y,dens); shading interp							% density
	hold on
	scatter(data(:,1),data(:,2),1,'w.')				% all datapoints 
	scatter(data(G.Opts.s,1),data(G.Opts.s,2),1,'rx')				% start points
	plot(G.y(1,:),G.y(2,:),'r','LineWidth',3)% path
    colorbar
	xlabel(statenames(combination(1)))
	ylabel(statenames(combination(2)))
    hold off

% Scatter plot
figure(2)
subplot(1,2,1)
hold on
scatter(data(:,1),data(:,2),8,ERA.a_single_cell_Variance)
colormap('copper')
set(gca,'CLim',[0,prctile(ERA.a_single_cell_Variance,95)*1.2])
shading interp
xlabel(opts.Ynames(combination(1)))
ylabel(opts.Ynames(combination(2)))
hold off
% Variance/Expectation plot
subplot(1,2,2)
hold on
scatter([ERA.a_single_cell_Expectation{:}],ERA.a_single_cell_Variance,8,ERA.a_single_cell_Variance)
set(gca,'CLim',[0,prctile(ERA.a_single_cell_Variance,95)*1.2])
colorbar
xlabel('E(a)')
ylabel('Var(a)')
set(gca,'YLim',[0,prctile(ERA.a_single_cell_Variance,95)*1.2])
combi=num2str(opts.PathIndex);
title = ['Variance in a of single cells', combi];
suptitle(title)
hold off
end

