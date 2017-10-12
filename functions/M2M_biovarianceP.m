function M2M_biovarianceP(simdata)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
%% Biological variance
for i=1:5
%     xlim([0 600])
    plot(simdata{1,i}.time,simdata{1,i}.statevalues(:,6),'LineWidth',2),
    hold on
    grid on
    xlabel('time (h)'), ylabel('concentration (AU)')
% set(gca,'XLim',[0 60])
% set(gca,'XTick',(0:10:60))
end
i=1:5;
legend(strcat('Cell No.',num2str(i')))
end

