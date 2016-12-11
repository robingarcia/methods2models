filename = uigetfile('~/methods2models/datasets');
datafile = importdata(filename);
dt = 0.1;
tmax = 5000;
t = 0:dt:tmax;
n = size(datafile,2);

for j = 1:n
 %   for i = 1:n 
    %state = datafile{1,1};
    state = datafile{j}(:,1);
    figure(900+j);
    state_plot(j) = plot(t,state);
    title('Stateplot')
    xlabel('time')
    ylabel('AU')
    hold on;
    [autocor,lags] = xcorr(state-mean(state));
    figure(800+j);
    xcorr_plot(j) = plot(lags/120,autocor);
    hold on;
    
 %   end
end
