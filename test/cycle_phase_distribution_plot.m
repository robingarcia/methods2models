%% Histogramm Phasenverteilung
figure
ax1=subplot(2,2,1);
histogram(t_period(1,:))
title('Periode')
ax2=subplot(2,2,2);
histogram(t_period(2,:))
title('G1-Phase')
ax3=subplot(2,2,3);
histogram(t_period(3,:))
title('S-Phase')
ax4=subplot(2,2,4);
histogram(t_period(4,:))
title('G2-Phase')