%Histogramm für die verschiedenen Startbedingungen
ip = [1,2,3,4,5,6,7,11,12];
% a = floor(size(ic,1)^(1/2));
% b = ceil(size(ic,1)/a);
a = floor(size(ip,2)^(1/2));
b = ceil(size(ip,2)/a);

% Loop counter
loopcnt=0;
sum=0;


figure(1)
while(sum <size(ip,2))

    for i = ip%1:size(ic,1)
%     while(sum <=size(ip,2))
    sum = sum + 1;
    disp(sum)

%     ax.XLim = [0 1];
%     subplot(b,a,i)
    subplot(b,a,sum)
%     h=histogram(ic(i,:),2000);
    h=histogram(rndmic(i,:),2000);

    title(statenames(i))
    xlabel('Concentration (a.u.)')
    ylabel('Number of cells')
    xlim([0 1])
    set(gca,'FontSize',12) 
    end
end