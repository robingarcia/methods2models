%% Plot your dataset
%load('20170329T225509.mat');
%x = input('Input first protein:');
%y = input('Input second protein:');

for i = 1:31
    figure(1)
    hold on;
    grid on;
    %subplot(6,6,6)
    %s(i)=scatter(measurement{1,1}(i,:), measurement{1,1}(32,:))
    %s(i)=scatter(mydata(i,:), mydata(32,:));
    %plot3(mydata(x,:), mydata(y,:), mydata(32,:));
    %scatter(mydata(x,:), mydata(y,:),'b')%, mydata(32,:),'*');
    hold on
    %scatter(errordata(x,:), errordata(y,:),'r')%, errordata(32,:));
    scatter3(measurement(i,:),measurement(2,:),measurement(466,:))
end


