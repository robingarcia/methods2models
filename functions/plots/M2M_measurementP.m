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
for i=1:300
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


%% TEST ENVIRONMENT!!!
% blubb=horzcat(t_period,t_period);
% timepoint=MYDATA(33,:);
dna_points=MYDATA(32,:);
dna_points(1:100)
if dna_points(1:100) <=2
%    yyaxis left
        scatter(MYDATA(33,1:100),MYDATA(12,1:100),'ro','filled')
        title(statenames(12))
        xlabel('Time [h]')
        ylabel('Concentration (a.u.)')
        
        hold on
%         yyaxis right
        scatter(MYDATA(33,1:100),MYDATA(32,1:100),'r')
        ylabel('DNA')
        axis([0 max(MYDATA(end,:))+1 1.5 4.5])
        grid on
        hold off
elseif dna_points(1:100) > 2 & dna_points(1:100) < 4
%         yyaxis left

        scatter(MYDATA(33,1:100),MYDATA(12,1:100),'go','filled')
        title(statenames(12))
        xlabel('Time [h]')
        ylabel('Concentration (a.u.)')
        
        hold on
%         yyaxis right
        scatter(MYDATA(33,1:100),MYDATA(32,1:100),'g')
        ylabel('DNA')
        axis([0 max(MYDATA(end,:))+1 1.5 4.5])
        grid on
        hold off
else
%     yyaxis left
        scatter(MYDATA(33,1:100),MYDATA(12,1:100),'bo','filled')
        title(statenames(12))
        xlabel('Time [h]')
        ylabel('Concentration (a.u.)')
        
        hold on
%         yyaxis right
        scatter(MYDATA(33,1:100),MYDATA(32,1:100),'b')
        ylabel('DNA')
        axis([0 max(MYDATA(end,:))+1 1.5 4.5])
        grid on
        hold off
end
    

%% TEST ENVIRONMENT 2 (PLOT WITH PLOTYY)
figure %new figure
%x_1 = (MYDATA(32,1:200) <=2)
%MYDATA(32,x_1)
%MYDATA(33,x_1)
x_logi = (MYDATA(32,1:200) <=2);
x_1 = MYDATA(33,x_logi);
y_1 = MYDATA(12,x_logi);
x_2 = MYDATA(33,x_logi);
y_2 = MYDATA(32,x_logi);

        hold on
        [ax,h1,h2]=plotyy(x_1,y_1,x_2,y_2,'scatter','scatter');
        set(h1,'markerfacecolor','r')
        set(h2,'markerfacecolor','r')
%         set(h1,'LineStyle','o')
%         set(h2,'LineStyle','*')
        set(h1,'MarkerEdgeColor','none')
        set(h2,'MarkerEdgeColor','none')
%         hold off
        
x_logi = (MYDATA(32,1:200) > 2 & MYDATA(32,1:200) <4);
x_1 = MYDATA(33,x_logi);
y_1 = MYDATA(12,x_logi);
x_2 = MYDATA(33,x_logi);
y_2 = MYDATA(32,x_logi);

%          hold on
        [ax,h3,h4]=plotyy(x_1,y_1,x_2,y_2,'scatter','scatter');
        set(h3,'markerfacecolor','g')
        set(h4,'markerfacecolor','g')
%         set(h3,'LineStyle','.')
%         set(h4,'LineStyle','o')
        set(h3,'MarkerEdgeColor','none')
        set(h4,'MarkerEdgeColor','none')
%         hold off
        
x_logi = (MYDATA(32,1:200) >=4);
x_1 = MYDATA(33,x_logi);
y_1 = MYDATA(12,x_logi);
x_2 = MYDATA(33,x_logi);
y_2 = MYDATA(32,x_logi);

%          hold on
        [ax,h5,h6]=plotyy(x_1,y_1,x_2,y_2,'scatter','scatter');
        set(h5,'markerfacecolor','b')
        set(h6,'markerfacecolor','b')
%         set(h5,'LineStyle','o')
%         set(h6,'LineStyle','o')
        set(h5,'MarkerEdgeColor','none')
        set(h6,'MarkerEdgeColor','none')
        ylabel(hax(1),'Konzentration (a.u)') % left y-axis 
        ylabel(hax(2),'DNA') % right y-axis
        hold off
%% Old try
x_1 = MYDATA(33,1:200);
y_1 = MYDATA(12,1:200);
x_2 = MYDATA(33,1:200);
y_2 = MYDATA(32,1:200);
% [ax,h1,h2]=plotyy(x_1,y_1,x_2,y_2,'scatter');
if      dna_points(1:100) <=2
        hold on
        [ax,h1,h2]=plotyy(x_1,y_1,x_2,y_2,'scatter');
        set(h1,'markerfacecolor','r')
        set(h2,'markerfacecolor','r')
        hold off
elseif  dna_points(1:100) > 2 & dna_points(1:100) < 4
        hold on
        [ax,h1,h2]=plotyy(x_1,y_1,x_2,y_2,'scatter');
        set(h1,'markerfacecolor','g')
        set(h2,'markerfacecolor','g')
        hold off
else
        hold on
        [ax,h1,h2]=plotyy(x_1,y_1,x_2,y_2,'scatter');
        set(h1,'markerfacecolor','b')
        set(h2,'markerfacecolor','b')
        hold off
end
% set(h1,'markerfacecolor','g')
% set(h2,'markerfacecolor','r')
% set(h1,'MarkerEdgeColor','none')
% set(h2,'MarkerEdgeColor','none')
%%
for i=1:100
    dna_t=dna_points(:,i);
    if  dna_t <= 2

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

    elseif (dna_t > 2) && (dna_t < 4)
        yyaxis left

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

    else    

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
    end    
end
hold off

%% Separate picture Cdc20A
figure(1)
x_logi = (MYDATA(32,1:4000) <=2);
x_1 = MYDATA(33,x_logi);
y_1 = MYDATA(12,x_logi);
plot(x_1,y_1,'r.')
hold on
grid on
x_logi = (MYDATA(32,1:4000) > 2 & MYDATA(32,1:4000) <4);
x_1 = MYDATA(33,x_logi);
y_1 = MYDATA(12,x_logi);
plot(x_1,y_1,'g.')
x_logi = (MYDATA(32,1:4000) >=4);
x_1 = MYDATA(33,x_logi);
y_1 = MYDATA(12,x_logi);
plot(x_1,y_1,'b.')
legend('G1-Phase','S-Phase','G2-Phase','Location','northwest')
xlabel('Zeit [h]')
ylabel('Konzentration (a.u.)')
hold off
matlab2tikz( 'cdc20a.tex', 'height', '\fheight', 'width', '\fwidth','floatFormat','%.3g' )
%% Separate picture DNA
figure(1)
x_logi = (MYDATA(32,1:4000) <=2);
x_1 = MYDATA(33,x_logi);
y_1 = MYDATA(32,x_logi);
plot(x_1,y_1,'r.')
hold on
grid on
x_logi = (MYDATA(32,1:4000) > 2 & MYDATA(32,1:4000) <4);
x_1 = MYDATA(33,x_logi);
y_1 = MYDATA(32,x_logi);
plot(x_1,y_1,'g.')
x_logi = (MYDATA(32,1:4000) >=4);
x_1 = MYDATA(33,x_logi);
y_1 = MYDATA(32,x_logi);
plot(x_1,y_1,'b.')
legend('G1-Phase','S-Phase','G2-Phase','Location','southeast')
xlabel('Zeit [h]')
ylabel('Konzentration (a.u.)')
axis([0 max(MYDATA(end,:))+1 1.5 4.5])
hold off
matlab2tikz( 'dna.tex', 'height', '\fheight', 'width', '\fwidth','floatFormat','%.3g' )
%% matlab2tikz
% matlab2tikz( 'cdc20a_dna.tex', 'height', '\fheight', 'width', '\fwidth','floatFormat','%.3g' )
end

