%% KDE plot 
data=zeros(size(mydata,2),2);
name=storage.statenames;
% combi=WChooseK(1:27,2);
for i=[1,351]%1:size(combi,1)
    figure(i)
    data(:,1)=mydata(combi(i,1),:)';
    data(:,2)=mydata(combi(i,2),:)';
    [bandwidth,density,X,Y]=kde2d(data);
    contour3(X,Y,density,50)
    hold on
    plot(data(:,1),data(:,2),'r.','MarkerSize',5)
    title(name(combi(i,:)))
    xlabel(name(combi(i,1)))
    ylabel(name(combi(i,2)))
    
end