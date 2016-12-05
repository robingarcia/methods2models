%function [] = check4oscillation
% Script to check for oscillation in datasets
filename = uigetfile('~/methods2models/datasets');
datafile = importdata(filename);
t = 1:0.1:120;
data_xcorr = xcorr(datafile);
%dadafile = datafile(1,1:120);
% Plot the data
X = data_xcorr(1,:);
Y = data_xcorr(2,:);
plot(X,Y)
%xlabel('Time')
%ylabel('Statevalues')
%axis tight

%[autocor,lags] = xcorrIQM(dadafile(1,:),t');

%plot(t,autocor)
%xlabel('Time')
%ylabel('Autocorrelation')
%axis([0 120 0 3])

% Extract oscillation
%xcorrIQM(da
%end
