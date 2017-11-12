function M2M_measurementP(MYDATA,statenames)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% %% DNA subplot with important proteins
% ip = [2,3,5,12];
% a = floor(size(ip,2)^(1/2));
% b = ceil(size(ip,2)/a);
% sum=0;
% figure(1)
% while(sum <size(ip,2))
% for i = ip
%    sum = sum + 1;
% %    disp(sum)
%    hold on
%    yyaxis left
% %    subplot(b,a,sum)
%    scatter(MYDATA(33,[1:500]),normdata(MYDATA(12,[1:500])));
%    legend(statenames(i))
% %     title('DNA duplication')
%     xlabel('Time [h]')
%     ylabel('Concentration (a.u.)')
%     
%     yyaxis right
%     scatter(MYDATA(33,[1:500]),MYDATA(32,[1:500]),'*')
%     ylabel('DNA')
%     axis([0 max(MYDATA(end,:))+1 1.5 4.5])
%     grid on
%     hold off
% end
% end
%% Gradient mapped on species
% blubb=horzcat(t_period,t_period);
% timepoint=MYDATA(33,:);
dna_points=MYDATA(32,:);
for i=1:100
%     time=timepoint(:,i);
    dna_t=dna_points(:,i);
%     p=blubb(1,i);
%     g1=blubb(2,i);
%     s=blubb(3,i);
%     g2=blubb(4,i);
%     
% %     P=p;
%     G1=g1;
%     S=g1+s;
    
%     hold on
    if  dna_t <= 2
%         hold on
        yyaxis left
        scatter(MYDATA(33,i),MYDATA(12,i),'ro','filled')
        title(statenames(12))
        xlabel('Time [h]')
        ylabel('Concentration (a.u.)')
        
        hold on
        yyaxis right
        scatter(MYDATA(33,i),MYDATA(32,i),'r')
        ylabel('DNA')
        axis([0 max(MYDATA(end,:))+1 1.5 4.5])
        grid on
%         hold off
    elseif (dna_t > 2) && (dna_t < 4)
        yyaxis left
%         hold on
        scatter(MYDATA(33,i),MYDATA(12,i),'go','filled')
        title(statenames(12))
        xlabel('Time [h]')
        ylabel('Concentration (a.u.)')
        
        hold on
        yyaxis right
        scatter(MYDATA(33,i),MYDATA(32,i),'g')
        ylabel('DNA')
        axis([0 max(MYDATA(end,:))+1 1.5 4.5])
        grid on
%         hold off
    else    
%         hold on
        yyaxis left
        scatter(MYDATA(33,i),MYDATA(12,i),'bo','filled')
        title(statenames(12))
        xlabel('Time [h]')
        ylabel('Concentration (a.u.)')
        
        hold on
        yyaxis right
        scatter(MYDATA(33,i),MYDATA(32,i),'b')
        ylabel('DNA')
        axis([0 max(MYDATA(end,:))+1 1.5 4.5])
        grid on
%         hold off
    end
    
end
hold off
% hold off
% %% Plot all a histogram
% for i=1:32
%    figure(i)
%    histogram(MYDATA(i,:))
%    title(statenames(i))
% end

%% matlab2tikz
% matlab2tikz( 'cdc20a_dna.tex', 'height', '\fheight', 'width', '\fwidth','floatFormat','%.3g' )
end

