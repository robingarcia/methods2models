function fh = Var_E_plot(results,i)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
rect = [20 20 800 600];
fh(1) = figure('Color','w','Position',rect);
scatter([results.a_Est(i,:)],results.Var_a(i,:),8,results.a_Est(i,:))
set(gca,'CLim',[0,prctile(results.a_Est(i,:),95)*1.2])
colorbar
xlabel('E(a)')
ylabel('Var(a)')
set(gca,'YLim',[0,prctile(results.Var_a(i,:),95)*1.2])
%combination=num2str(results.comb);
%title = ['Variance in a of single cells', combination];
%suptitle(title)
end

