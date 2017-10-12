function M2M_startP(original_data,lb,statenames)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%% Plot all important cyclines
    grid on
    hold on
    plot(original_data.time,original_data.statevalues(:,[2,3,5,12]),'LineWidth',2)
    xlim([950 990])
    legend(statenames([2,3,5,12]));
    xlabel('time (h)'), ylabel('concentration (AU)')
    title('MATLAB cell cycle model')
    plot(original_data.time(lb),original_data.statevalues(lb,[2,3,5,12]),'rx','LineWidth',2)
    grid on
    %     matlab2tikz

end

