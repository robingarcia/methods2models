function G = PathfromWanderlust(wdata,opts,start)

%% function to construct a set of trajectories that can be used in ERA or other further analysis methods
% The algorithme uses the wanderlust algorithm described in:
% Bendall SC, Davis KL, Amir E-AD, Tadmor MD, Simonds EF, Chen TJ, et al. 
% Single-cell trajectory detection uncovers progression and regulatory coordination in human B cell development. 
% Cell [Internet]. Elsevier; 2014 Apr 24 [cited 2014 Jul 10];157(3):714–25. 
% Available from: http://www.ncbi.nlm.nih.gov/pubmed/24766814
% 
%% INPUT
%
% wdata		- nxd data matrix of n single cells and d dimensional readout
% opts		- options struct for wanderlust
%
%% Output
%
% G			- Wanderlust algorithm output
%% -------------------------------------------

% Check inputs
params = [];
if isfield(opts,'wanderlust')
	params = opts.wanderlust;
else
end

if ~isfield(params,'wanderlust_weights') 
	params.wanderlust_weights = ones(1,length(opts.PathIndex));
end

% prepare data for wanderlust  (nxd)
o_data	= wdata(:,opts.PathIndex);
data	= o_data;

% set start point
emptys = 0;
if isfield(params,'s')
	emptys = isempty(params.s);
end

% dialog to set startpoint manually
% if ~isfield(params,'s') | emptys
% 	rect = [20 20 800 600];
% 	fh= figure('Color','w','Position',rect);
% 	psc = scatter(data(:,1),data(:,2),'ob');
% 	title('Click on starting point for wanderlust')
% 	xlabel(opts.Ynames(opts.PathIndex(1)))
% 	ylabel(opts.Ynames(opts.PathIndex(2)))
% 	hold on
    x_coords = start(1);
    y_coords = start(end);
	%[x_coords,y_coords]  = ginput_ax_mod2(gca,1); % Klick here :3
	ballsize = [0.002,0.02];
	inball = (data(:,1)-x_coords).^2 < ballsize(1) & (data(:,2)-y_coords).^2 < ballsize(2); %n-sphere
	%psc = scatter(data(inball,1),data(inball,2),'or');
	params.s = find(inball);% index to the set of start points
%end

% normalize data
if (params.normalize)
	data = data-repmat(prctile(data, 1, 1), size(data,1),1);
	data = data./repmat(prctile((data), 99, 1),size(data,1),1);
end

% weight the data
data = data.*repmat(params.wanderlust_weights,size(data,1),1);

% compute trajectory
G = wanderlust(data,params);

%% Visualize the result
% get mean wanderlust path
G = getMeanWanderlustPath(G,o_data,opts);


