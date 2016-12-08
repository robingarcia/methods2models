filename = uigetfile('~/methods2models/datasets');
datafile = importdata(filename);
t = 0:0.1:10000;
n = size(datafile,2);

for j = 1:n
    for i = 1:n 
    %state = datafile{1,1};
    state = datafile{n}(:,j);
    figure(900+i);
    state_plot(i) = plot(t,state);
    title('Stateplot')
    xlabel('time')
    ylabel('AU')
    hold on;
    [autocor,lags] = xcorr(state,t,'coeff');
    figure(800+i);
    xcorr_plot(i) = plot(lags/120,autocor);
    hold on;
    
    end
end
