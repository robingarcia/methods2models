oscillation_temp
close all
oscillation_temp
pks =findpeaks(autocor);
plot(pks)
[pks,pos] =findpeaks(autocor);
plot(diff(lags(pos)))
mean(diff(lags(pos)))

ans =

  299.7711

plot(t,state)
mean(diff(lags(pos)*0.1))

ans =

   29.9771 % Diesen wert für die versch. ICs plotten. Schwellwert definieren. 
   

minmax(lags)

ans =

      -50000       50000

plot(t,state)
plot(diff(lags(pos)))
[pks,pos] =findpeaks(autocor);
