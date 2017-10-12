function M2M_newICP(simdata,LB,statenames)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%%
plot(simdata{1,1}.time,simdata{1,1}.statevalues(:,[2,3,5,12]),'LineWidth',2)
hold on
plot(simdata{1,1}.time(LB(1)),simdata{1,1}.statevalues(LB(1),[2,3,5,12]),'r*','LineWidth',4)
set(gca,'XLim',[900 1000])
legend(statenames([2,3,5,12]))
xlabel('time (h)')
ylabel('Concentration (AU)')
grid on
matlab2tikz('new_ic.tex', 'height', '\fheight', 'width', '\fwidth' )
end

