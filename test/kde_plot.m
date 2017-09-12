%% KDE plot 
data=zeros(size(mydata,2),2);
for i=1:27
    figure(i)
    data(:,1)=mydata(i,:)';
    data(:,2)=mydata(end,:)';
    [bandwidth,density,X,Y]=kde2d(data);
    contour3(X,Y,density,50)
    hold on
    plot(data(:,1),data(:,2),'r.','MarkerSize',5)
end

%% Best combination
    data(:,1)=mydata(11,:)';
    data(:,2)=mydata(end,:)';
    [bandwidth,density,X,Y]=kde2d(data);
    contour3(X,Y,density,50)
    hold on
    plot(data(:,1),data(:,2),'r.','MarkerSize',5)
    
%% Scatterhist
scatterhist(data(:,1),data(:,2))
