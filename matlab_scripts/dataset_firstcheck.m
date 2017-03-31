%% Plot your dataset
%load('20170329T225509.mat');

for i = 1:31
    figure(1)
    hold on;
    subplot(6,6,i)
    %s(i)=scatter(measurement{1,1}(i,:), measurement{1,1}(32,:))
    s(i)=scatter(mydata(32,:), mydata(i,:));
end
