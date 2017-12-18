function M2M_transformationP(NewPathDensity,newScale)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
a_pdf=newScale.pdf;
figure
subplot(1,2,1)
plot(NewPathDensity.s,NewPathDensity.f_spdf(NewPathDensity.s))
title('Wahrscheinlichkeitsdichte')
xlabel('s')
ylabel('Zelldichte')

subplot(1,2,2)
plot(NewPathDensity.a,a_pdf(NewPathDensity.a))
% title('Wahrscheinlichkeitsfunktion (Alter)')
xlabel('Alter [h]')
ylabel('Zelldichte')
end

