%% Test bandwidth perfomance

% Buildin
tic
data=[randn(50000,2);randn(50000,1)+3.5, randn(50000,1);];
[bandwidth,density,X,Y]=kde2d(data);
contour3(X,Y,density,50), hold on
plot(data(:,1),data(:,2),'r.','MarkerSize',5)
toc
% % Mydata
% % mydata=[randn(5000,2);randn(5000,1)+3.5, randn(5000,1);];
% [bandwidth,density,X,Y]=kde2d(errordata);
% contour3(X,Y,density,50), hold on
% plot(errordata(:,1),errordata(:,2),'r.','MarkerSize',5)