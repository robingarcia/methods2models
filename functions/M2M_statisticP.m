function M2M_statisticP(NewPathDensity)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
figure
subplot(2,1,1)
plot(NewPathDensity.s,NewPathDensity.f_spdf(NewPathDensity.s))
title('Wahrscheinlichkeitsdichte')
xlabel('s')
ylabel('f(s)')

subplot(2,1,2)
plot(NewPathDensity.s,NewPathDensity.f_scdf(NewPathDensity.s))
title('Verteilungsfunktion')
xlabel('s')
ylabel('F(s)')

% subplot(2,2,3:4)
% plot(NewPathDensity.s,NewPathDensity.f_spdf_single(NewPathDensity.s))
% xlabel('s')
% ylabel('f(s)')
end

