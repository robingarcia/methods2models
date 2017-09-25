%% KDE plot 
data=zeros(size(mydata,2),2);
name=storage.statenames;
combi=WChooseK(1:27,2);
for i=1:5%size(combi,1)
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
%% Best combination
    data(:,1)=mydata(11,:)';
    data(:,2)=mydata(end,:)';
    [bandwidth,density,X,Y]=kde2d(data);
    contour3(X,Y,density,50)
    hold on
    plot(data(:,1),data(:,2),'r.','MarkerSize',5)
    
%% Scatterhist
scatterhist(data(:,1),data(:,2))
scatterhist(errordata(7,:),errordata(28,:))
scatterhist(errordata(11,:),errordata(28,:))
scatter3(errordata(7,:),errordata(11,:),errordata(28,:))

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


%% Scatter best and worst
figure(1)
scatterhist(errordata(7,:),errordata(28,:))
figure(2)
scatterhist(errordata(11,:),errordata(28,:))
figure(3)
scatter3(errordata(7,:),errordata(11,:),errordata(28,:))
figure(4)
scatterhist(errordata(16,:),errordata(28,:))
figure(5)
scatterhist(errordata(24,:),errordata(28,:))
figure(6)
scatter3(errordata(16,:),errordata(24,:),errordata(28,:))

%% KDE plot after wanderlust
C = nchoosek(1:d,2); %WChooseK ? 
a = floor(size(C,1)^(1/2));
b = ceil(size(C,1)/a);



rect = [20 20 800 600];
G.fh = figure('Color','w','Position',rect);

for i = 1:size(C,1)
	
    subplot(a,b,i)
	[~,dens,X,Y] = kde2d(data(:,C(i,:)));
	pcolor(X,Y,dens); shading interp							% density
	hold on
	scatter(data(:,C(i,1)),data(:,C(i,2)),1,'w.')				% all datapoints 
	scatter(data(G.Opts.s,C(i,1)),data(G.Opts.s,C(i,2)),1,'rx')				% start points
	plot(ywant(C(i,1),:),ywant(C(i,2),:),'r','LineWidth',3)		% path
	xlabel(dimension_names{C(i,1)})
	ylabel(dimension_names{C(i,2)})
 
end

