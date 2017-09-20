%% Plot all states
for i = [2,3,5,6,10]
   figure(i)
   scatter(normdata(errordata(28,:)),normdata(errordata(i,:)))
hold on
    scatter(normdata(w_path(28,:)),normdata(w_path(i,:)))
end

%% Plot all // getmeanWanderlustpath
y = data;
[~,d] = size(y);


if nargin > 2
	if isfield(opts,'doplots')
		doplots = opts.doplots;
	end
end
if doplots
	if (isfield(opts,'Ynames') && isfield(opts,'PathIndex'))
		dimension_names = opts.Ynames(opts.PathIndex);
	else 
		dimension_names = sprintfc('dim %i',1:d);
	end
end


% normalize all paths and take the mean
normGT = bsxfun(@times,(bsxfun(@minus,G.T,min(G.T')')), 1./(max(G.T')'- min(G.T')'));
x= mean(normGT);

% generate path coordinates with moving average
xwant = linspace(0,1,100);
binsize =0.2;
ywant = moving_average(x,y',xwant,binsize);%NaN are generated!!!!!!!!!!!!!!


% subplot layout
% possible combinations of dimensions in 2d
% C = nchoosek(1:d,2); %WChooseK ? 
% a = floor(size(C,1)^(1/2));
% b = ceil(size(C,1)/a);



rect = [20 20 800 600];
G.fh = figure('Color','w','Position',rect);

for i = 1:27 %[2,3,5,6,10]
    figure(i)
%     subplot(a,b,i)
    combi_data=[data(:,i),data(:,28)];
	[~,dens,X,Y] = kde2d(combi_data);
	pcolor(X,Y,dens); shading interp							% density
	hold on
	scatter(combi_data(:,1),combi_data(:,2),1,'w.')				% all datapoints 
	scatter(data(G.Opts.s,1),data(G.Opts.s,2),1,'rx')				% start points
	plot(ywant(i,:),ywant(28,:),'r','LineWidth',3)		% path
% 	xlabel(dimension_names{C(i,1)})
% 	ylabel(dimension_names{C(i,2)})
 
end


G.x = xwant;
G.y = ywant;