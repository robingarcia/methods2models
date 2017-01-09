filename = uigetfile('~/methods2models/datasets');
datafile = importdata(filename);
dt = 0.1;
tmax = 1000;
t = 0:dt:tmax;
n = size(datafile,2);

for j = 1:n
    state = datafile{j}(:,1);
    [autocor,lags] = xcorr(state-mean(state)); 
end
%pks = findpeaks(autocor);
%plot(pks);
[pks,pos] =findpeaks(autocor);
plot(diff(lags(pos)));
mean(diff(lags(pos)));

%plot(state)
mean(diff(lags(pos)*0.1))
minmax(lags)

%plot(state)
%plot(diff(lags(pos)))
%[pks,pos] =findpeaks(autocor);
