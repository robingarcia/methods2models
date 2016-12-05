function [] = check4oscillation()
% Script to check for oscillation in datasets
filename = uigetfile('~/methods2models/datasets');
datafile = importdata(filename);
t = 0:0.1:120;
n = size(datafile,2);
%figure
for j = 1:31 %31 Komponenten 
    %figure(j)
    for i =1:n % n Versch. ICs
    y = datafile{i}(:,j);
    subplot(10,3,i)
    plot(t,y);
    title('j')
    xlabel('time')
    ylabel('AU')
    hold on;
    %title('Fourth subplot')
    %endian = xcorr(y);
    end
    %for j = 1:31
    %signa(i).vec(j).S = signal_i(:,j);
end


%signal_1 = datafile{1,1};
%signal_2 = datafile{1,2};
%signal_3 = datafile{1,3};
%signal_1(:,1);
%signal_2(:,1);
%plot(t,signa_i);
%data_xcorr = xcorr(datafile{1,1});
%for i = 1:3 
%    plot(t,datafile{1,i});
%    hold on;

%pxcorr= xcorr(signal_1(:,1),signal_2(:,1), 'coeff'); 
%plot(pxcorr);
end

%plot(datafile{1}(:,1),datafile{2}(:,1))
%plot(t,datafile{2}(:,1))
%hold on
%plot(t,datafile{1}(:,1))
