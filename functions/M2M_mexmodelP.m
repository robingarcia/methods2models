function M2M_mexmodelP(original_data,statenames)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%% Plot all important cyclines
    grid on
    plot(original_data.time,original_data.statevalues(:,[2,3,5,12]),'LineWidth',1.0)
    xlim([0 100])
    legend(statenames([2,3,5,12]))
    xlabel('time (h)'), ylabel('concentration (AU)')
%     title('MATLAB cell cycle model')
    hold on
    grid on
    
%%     matlab2tikz
matlab2tikz('original_toettcher.tex','height', '4cm', 'width', '8cm','floatFormat','%.3g' )
end

