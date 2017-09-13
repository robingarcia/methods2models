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

%% Plot all
[~,d] = size(y_data);
% normalize all paths and take the mean
normGT = bsxfun(@times,(bsxfun(@minus,G.T,min(G.T')')), 1./(max(G.T')'- min(G.T')'));
x= mean(normGT);

% generate path coordinates with moving average
xwant = linspace(0,1,100);
binsize =0.2;
ywant = moving_average(x,y_data',xwant,binsize);%NaN are generated!!!!!!!!!!!!!!
C = WChooseK(1:d,2); %WChooseK ? 
for i = [53,78,125,147,225]%1:size(C,1)
    figure(i)
	rect = [20 20 800 600];
    G.fh = figure('Color','w','Position',rect);
%     subplot(a,b,i)
	[~,dens,X,Y] = kde2d(data(:,C(i,:)));
	pcolor(X,Y,dens); shading interp							% density
	hold on
	scatter(data(:,C(i,1)),data(:,C(i,2)),1,'w.')				% all datapoints 
	scatter(data(G.Opts.s,C(i,1)),data(G.Opts.s,C(i,2)),1,'rx')				% start points
	plot(ywant(C(i,1),:),ywant(C(i,2),:),'r','LineWidth',3)		% path
% 	xlabel(dimension_names{C(i,1)})
% 	ylabel(dimension_names{C(i,2)})
 
end
