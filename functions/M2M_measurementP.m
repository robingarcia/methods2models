function M2M_measurementP(MYDATA,statenames,t_period)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%% DNA subplot with important proteins
ip = [2,3,5,12];
a = floor(size(ip,2)^(1/2));
b = ceil(size(ip,2)/a);
sum=0;
figure(1)
while(sum <size(ip,2))
for i = ip
   sum = sum + 1;
   disp(sum)
%    hold on
   yyaxis left
%    subplot(b,a,sum)
   scatter(MYDATA(33,[1:500]),normdata(MYDATA(12,[1:500])));
   legend(statenames(i))
%     title('DNA duplication')
    xlabel('Time [h]')
    ylabel('Concentration (a.u.)')
    
    yyaxis right
    scatter(MYDATA(33,[1:500]),MYDATA(32,[1:500]),'*')
    ylabel('DNA')
    axis([0 max(MYDATA(end,:))+1 1.5 4.5])
    grid on
end
end

%% DNA gradient
blubb=horzcat(t_period,t_period);
timepoint=MYDATA(33,:);
for i=1:1000
    time=timepoint(:,i);
    p=blubb(1,i);
    g1=blubb(2,i);
    s=blubb(3,i);
    g2=blubb(4,i);
    
%     P=p;
    G1=g1;
    S=g1+s;
    
    hold on
    if  time < G1
        scatter(MYDATA(33,i),MYDATA(32,i),'ro')
        ylabel('DNA')
    axis([0 max(MYDATA(end,:))+1 1.5 4.5])
    grid on
    elseif time < S
        scatter(MYDATA(33,i),MYDATA(32,i),'gx')
        ylabel('DNA')
    axis([0 max(MYDATA(end,:))+1 1.5 4.5])
    grid on
    else time > S;
        scatter(MYDATA(33,i),MYDATA(32,i),'b*')
        ylabel('DNA')
    axis([0 max(MYDATA(end,:))+1 1.5 4.5])
    grid on
    end
end
% matlab2tikz('dna_duplication.tex', 'height', '\fheight', 'width', '\fwidth' )


% x = linspace(0,3*pi,200);
% y = cos(x) + rand(1,200);
% sz = 25;
% c = linspace(1,10,length(x));
% scatter(x,y,sz,c,'filled')

%% Gradient mapped on species
blubb=horzcat(t_period,t_period);
timepoint=MYDATA(33,:);
for i=1:1000
    time=timepoint(:,i);
    p=blubb(1,i);
    g1=blubb(2,i);
    s=blubb(3,i);
%     g2=blubb(4,i);
    
    P=p;
    G1=g1;
    S=g1+s;
    
%     hold on
    if  time < G1
        scatter(MYDATA(33,:),MYDATA(3,:),'r')
        ylabel('DNA')
    axis([0 max(MYDATA(end,:))+1 1.5 4.5])
    grid on
    elseif time < S
        scatter(MYDATA(33,:),MYDATA(3,:),'g')
        ylabel('DNA')
    axis([0 max(MYDATA(end,:))+1 1.5 4.5])
    grid on
    else    time > S;
        scatter(MYDATA(33,:),MYDATA(3,:),'b')
        ylabel('DNA')
    axis([0 max(MYDATA(end,:))+1 1.5 4.5])
    grid on
    end
    hold on
end
end

