function M2M_durationP(simdata,t_period)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
%% Plot the different phases g1,s,g2 and the period
figure
subplot(2,2,1);
histogram(t_period(1,:),'FaceColor','r')
xlabel('Time (h)'), ylabel('Number of cells')
title('Period')
subplot(2,2,2);
histogram(t_period(2,:),'FaceColor','g')
xlabel('Time (h)'), ylabel('Number of cells')
title('G1-Phase')
subplot(2,2,3);
histogram(t_period(3,:),3,'FaceColor','b')
xlabel('Time (h)'), ylabel('Number of cells')
title('S-Phase')
subplot(2,2,4);
histogram(t_period(4,:),7,'FaceColor','y')
xlabel('Time (h)'), ylabel('Number of cells')
title('G2-Phase')

%% Period
histogram(t_period(1,:),'FaceColor','r')
xlabel('Period (h)'), ylabel('Number of cells')
title('Period')

matlab2tikz('period_all.tex','height', '\fheight', 'width', '\fwidth','floatFormat','%.3g' )

%% G1-Phase
histogram(t_period(2,:),'FaceColor','g')
xlabel('Period (h)'), ylabel('Number of cells')
title('G1-Phase')

matlab2tikz('g1_phase.tex','height', '\fheight', 'width', '\fwidth','floatFormat','%.3g' )

%% S-Phase
histogram(t_period(3,:),3,'FaceColor','b')
xlabel('Period (h)'), ylabel('Number of cells')
title('S-Phase')

matlab2tikz('s_phase.tex','height', '\fheight', 'width', '\fwidth','floatFormat','%.3g' )

%% G2-Phase
histogram(t_period(4,:),7,'FaceColor','y')
xlabel('Period (h)'), ylabel('Number of cells')
title('G2-Phase')

matlab2tikz('g2_phase.tex','height', '\fheight', 'width', '\fwidth','floatFormat','%.3g' )

%% still buggy?
% for i=1%[81,225]
% %     xlim([900 1000])
%     period=ceil(t_period(1,i));
%     g1=ceil(t_period(2,i));
%     s=ceil(t_period(3,i));
%     g2=ceil(t_period(4,i));
%     plot(simdata{1,i}.time(2000-period:2000),simdata{1,i}.statevalues(2000-period:2000,:),'k','LineWidth',3,'DisplayName','Period')
%     hold on
%     plot(simdata{1,i}.time(2000-g1:2000),simdata{1,i}.statevalues(2000-g1:2000,:),'c','LineWidth',3,'DisplayName','G1')
%     hold on
%     plot(simdata{1,i}.time(2000-s:2000),simdata{1,i}.statevalues(2000-s:2000,:),'g','LineWidth',3,'DisplayName','S')
%     hold on
%     plot(simdata{1,i}.time(2000-g2:2000),simdata{1,i}.statevalues(2000-g2:2000,:),'r','LineWidth',3,'DisplayName','G2')
%     xlabel('time (h)'), ylabel('concentration (AU)')
% end
end

