%% Plot your dataset
%load('20170329T225509.mat');

for i = 1:31
    figure(i)
    scatterhist(measurement{1,1}(i,:), measurement{1,1}(32,:))
end