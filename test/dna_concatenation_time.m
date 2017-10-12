%% DNA concatenation timepoints
period = t_period(1,1);
g1 = t_period(2,1);
s = t_period(3,1);
g2 = t_period(4,1);
m = 2/s;
c = m;
times = tF(end)/period;
ub=t_period(5,1);
lb=t_period(6,1);

yDNA_temp = zeros(1,length(tF));

G1 = 2*ones(1,g1);
G2 = 4*ones(1,g2);
fh=@(x)x*m+c;
S = fh(g1:period-g2);

y_DNA_temp = horzcat(G1,S);
y_DNA_temp = horzcat(y_DNA_temp,G2);
% y_DNA_temp = horzcat(G1,G2);

dna_all = repmat(y_DNA_temp,1,period);


figure
for i = [6,12]%[1,2,3,5,6,12]%[1,2,3,5]
grid on
yyaxis left
plot(original_statevalues(i,10:120),'LineWidth',2);
plot(random_statevalues{1,1}(10:120,i),'LineWidth',2);
% plot(original_statevalues(i,lb:ub),'LineWidth',2);

hold on
legend(statenames(i))
title('DNA Duplikation')
xlabel('Zeit [h]')
ylabel('Konzentration (a.u.)')
end
i=[6,12];%[1,2,3,5,6,12];
legend(statenames(i))
yyaxis right
plot(dna_all(10:120), 'LineWidth',4,'DisplayName','DNA');
% plot(dna_all(lb:ub), 'LineWidth',4,'DisplayName','DNA');

ylabel('DNA')
hold on

%% Limit ciycle and findpeaks
plot(original_statevalues(12,:))
hold on
for i = 1:2000
plot(random_statevalues{1,i}(:,12))
hold on
end

%% Plot DNA and important cyclines
 % c - a matrix defining some outputs for plotting
c = zeros(4, 33);
c(1,[3 4 9 10 30]) = 1;    % CycBT
c(2,[2 15 29]) = 1;        % CycAT
c(3,[5 16 31]) = 1;        % CycET
c(4,12) = 1;               % Cdc20A  

% fh = figure('Position',[1 1 8 6]*30,'Units','centimeters');
% fh.Pos
for i = [1,2,3,4,5,6,7,11,12]%[1,2,3,5,7,12]
    hold on
    grid on
    yyaxis left
    xx=MYDATA(33,:);
%     yy1=MYDATA(1,:);
%     yy2=MYDATA(2,:);
%     yy3=MYDATA(3,:);
%     yy5=MYDATA(5,:);
%     yy6=MYDATA(6,:);
%     yy12=MYDATA(12,:);
    yy1=normdata(MYDATA(1,:));
    yy2=normdata(MYDATA(2,:));
    yy3=normdata(MYDATA(3,:));
    yy4=normdata(MYDATA(4,:));
    yy5=normdata(MYDATA(5,:));
    yy6=normdata(MYDATA(6,:));
    yy7=normdata(MYDATA(7,:));
    yy11=normdata(MYDATA(11,:));
    yy12=normdata(MYDATA(12,:));
    plot(xx,yy1,'r.',xx,yy2,'rx',xx,yy3,'ro',xx,yy4,'g.',xx,yy5,'gx',xx,yy6,'go',xx,yy7,'b.',xx,yy11,'bx',xx,yy12,'bo')
%     plot(xx,yy1,'r.',xx,yy2,'g.',xx,yy3,'b.',xx,yy5,'y.',xx,yy6,'m.',xx,yy12,'c.')
% plot(xx, c*mydata,'LineWidth', 2)
    legend(statenames(i))
    title('DNA Duplikation')
    xlabel('Zeit [h]')
    ylabel('Konzentration (a.u.)')
end
i=[1,2,3,5,6,12];
legend(statenames(i))
yyaxis right
scatter(MYDATA(33,:),MYDATA(32,:))
ylabel('DNA')
axis([0 max(MYDATA(end,:))+1 1.5 4.5])
% ylabel('DNA')
% matlab2tikz('dna_broken.tex')
% legend(statenames(32))

%% DNA subplot with important proteins
ip = [1,2,3,4,5,6,7,11,12];
% a = floor(size(ic,1)^(1/2));
% b = ceil(size(ic,1)/a);
a = floor(size(ip,2)^(1/2));
b = ceil(size(ip,2)/a);
sum=0;
figure(1)
while(sum <size(ip,2))
for i = ip
   sum = sum + 1;
   disp(sum)
   hold on
   grid on
   yyaxis left
   subplot(b,a,sum)
   p=scatter(MYDATA(33,:),normdata(MYDATA(i,:)));
   legend(statenames(i))
    title('DNA duplication')
    xlabel('Time [h]')
    ylabel('Concentration (a.u.)')
    
    yyaxis right
    scatter(MYDATA(33,:),MYDATA(32,:),'*')
    ylabel('DNA')
    axis([0 max(MYDATA(end,:))+1 1.5 4.5])
end
end
% legend(statenames(ip))
% yyaxis right
% scatter(MYDATA(33,:),MYDATA(32,:),'*')
% ylabel('DNA')
% axis([0 max(MYDATA(end,:))+1 1.5 4.5])


