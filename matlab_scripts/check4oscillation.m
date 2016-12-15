function [freq] = check4oscillation()
% Script to check for oscillation in datasets

filename = uigetfile('~/methods2models/datasets');
datafile = importdata(filename);
%dt = 0.1;
%tmax = 5000;
%t = 0:dt:tmax;
n = size(datafile,2);
for j = 1:31 %31 Komponenten 
    %figure(j)
    for i =1:n % n Versch. ICs
    state = datafile{i}(:,j);
    subplot(4,8,j)
    plot(state);
    xlabel('time')
    ylabel('AU')
    hold on;
    end
end
%[autocor,lags] = xcorr(state-mean(state));
%[~,pos] =findpeaks(autocor);
%plot(diff(lags(pos)));
%mean(diff(lags(pos)));

%plot(state)
%freq = mean(diff(lags(pos)*0.1));
%minmax(lags)

%X = ['Frequence:', num2str(freq)];
%frequence = disp(X);

% Plot histogram
z = size(datafile{1,n});
check = cell(n,z(1,2));
for a = 1:31 %31 Komponenten 
    for b =1:n % n Versch. ICs
    check{b,a} = datafile{b}(:,a);
    end
end

statefreq = cell(n,z(1,2));
freq = cell(n,z(1,2));
figure
for c = 1:31; % Number of variables
    for d = 1:n; % Number of ICs
        statefreq{c,d} = datafile{d}(:,c);
        [autocor,lags] = xcorr(statefreq{c,d}-mean(statefreq{c,d}));
        [~,pos] =findpeaks(autocor);
        freq = mean(diff(lags(pos)*0.1));
        subplot(4,8,c)
        freq = round(freq);
        histogram(freq);
        hold on;
    end
end
end




