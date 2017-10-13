function M2M_biovarianceP(simdata)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
%% Biological variance
for i=1:2%1:5
%     xlim([0 600])
    plot(simdata{1,i}.time,simdata{1,i}.statevalues(:,2),'LineWidth',0.5)
    hold on
    grid on
    xlabel('time (h)'), ylabel('concentration (AU)')
    title('CycA')
% set(gca,'XLim',[0 60])
% set(gca,'XTick',(0:10:60))
end
i=1:5;
legend(strcat('Cell No.',num2str(i')))

%% Save with matlabtikz
% matlab2tikz('biologicalvariance.tex','standalone',true, 'height', '\fheight', 'width', '\fwidth','floatFormat','%.3g' )
matlab2tikz('biologicalvariance.tex', 'height', '4cm', 'width', '8cm','floatFormat','%.3g' )
end

