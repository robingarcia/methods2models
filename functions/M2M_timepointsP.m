function M2M_timepointsP(p_value,samples)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
%% Single timepoints via inversion method
f = figure;
p = uipanel('Parent',f,'BorderType','none');  
p.TitlePosition = 'centertop'; 
p.FontSize = 12;
p.FontWeight = 'bold';

subplot(1,2,1,'Parent',p)
histogram(p_value(:,1));
grid on
title('Uniform distribution')
ylabel('Number of cells')

subplot(1,2,2,'Parent',p)
histogram(samples(:,1));
grid on
title('New distribution $$f(a)=2 \gamma e^{- \gamma a}$$','Interpreter','latex')
xlabel('Periods (h)')
ylabel('Number of cells')
matlab2tikz( 'inversion.tex', 'height', '\fheight', 'width', '\fwidth' )
%% Uniform distribution
histogram(p_value(:,1));
grid on
title('Uniform distribution')
ylabel('Number of cells')
end

