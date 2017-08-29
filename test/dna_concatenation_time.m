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

% y_DNA_temp = horzcat(G1,S);
% y_DNA_temp = horzcat(y_DNA_temp,G2);
y_DNA_temp = horzcat(G1,G2);

dna_all = repmat(y_DNA_temp,1,period);


figure
for i = [1,2,3,5,6,12]%[1,2,3,5]
grid on
yyaxis left
% plot(original_statevalues(i,10:120),'LineWidth',2);
plot(original_statevalues(i,lb:ub),'LineWidth',2);

hold on
legend(statenames(i))
title('DNA Duplikation')
xlabel('Zeit [h]')
ylabel('Konzentration (a.u.)')
end
i=[1,2,3,5,6,12];
legend(statenames(i))
yyaxis right
% plot(dna_all(10:120), 'LineWidth',4,'DisplayName','DNA');
plot(dna_all(lb:ub), 'LineWidth',4,'DisplayName','DNA');

ylabel('DNA')
hold on

%% Limit ciycle and findpeaks
plot(original_statevalues(12,:))
hold on
for i = 1:2000
plot(random_statevalues{1,i}(:,12))
hold on
end
