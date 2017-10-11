function M2M_durationP(simdata,t_period)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
%% Plot the different phases g1,s,g2 and the period
figure
ax1=subplot(2,2,1);
histogram(t_period(1,:),'FaceColor','r')
xlabel('Period (h)'), ylabel('Number of cells')
title('Period')
ax2=subplot(2,2,2);
histogram(t_period(2,:),'FaceColor','g')
xlabel('Period (h)'), ylabel('Number of cells')
title('G1-Phase')
ax3=subplot(2,2,3);
histogram(t_period(3,:),3,'FaceColor','b')
xlabel('Period (h)'), ylabel('Number of cells')
title('S-Phase')
ax4=subplot(2,2,4);
histogram(t_period(4,:),7,'FaceColor','y')
xlabel('Period (h)'), ylabel('Number of cells')
title('G2-Phase')

%%
for i=1:100
%     xlim([900 1000])
    period=ceil(t_period(1,i));
    g1=ceil(t_period(2,i));
    s=ceil(t_period(3,i));
    g2=ceil(t_period(4,i));
    scatter(simdata{1,i}.time(2000-period:2000),simdata{1,i}.statevalues([2000-period:2000],5),'k','LineWidth',2)
    hold on
    scatter(simdata{1,i}.time(2000-g1:2000),simdata{1,i}.statevalues([2000-g1:2000],5),'c','LineWidth',2)
    hold on
    scatter(simdata{1,i}.time(2000-s:2000),simdata{1,i}.statevalues([2000-s:2000],5),'g','LineWidth',2)
    hold on
    scatter(simdata{1,i}.time(2000-g2:2000),simdata{1,i}.statevalues([2000-g2:2000],5),'r','LineWidth',2)
    xlabel('time (h)'), ylabel('concentration (AU)')
end
end

