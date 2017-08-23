%% Timepoints plot and selection
figure
ax1=subplot(2,2,1);
histogram(P_value(:,1))
title('1. Schnappschuss: Uniform')
ax2=subplot(2,2,2);
histogram(P_value(:,2))
title('2. Schnappschuss: Uniform')
ax3=subplot(2,2,3);
histogram(samples(:,1))
title('1. Schnappschuss')
ax4=subplot(2,2,4);
histogram(samples(:,2))
title('2. Schnappschuss')


