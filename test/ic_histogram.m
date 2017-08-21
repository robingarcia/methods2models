%Histogramm für die verschiedenen Startbedingungen
a = floor(size(ic,1)^(1/2));
b = ceil(size(ic,1)/a);
figure(1)
for i = 6%1:size(ic,1)
    %ax.XLim = [0 1];
%     subplot(b,a,i)
    h=histogram(ic(i,:),2000);
    title(statenames(i))
    xlabel('Concentration (a.u.)')
    ylabel('Number of cells')
    xlim([0 1])
    set(gca,'FontSize',12) 
end