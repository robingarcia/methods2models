function [G,y_data,inball] = PathfromWanderlust(wdata,opts,start,cmatrix)

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

if isfield(params,'wanderlust_weights') 
	params.wanderlust_weights = ones(1,length(opts.PathIndex))*10;
    %params.wanderlust_weights = ones(1,size(wdata,2))*10;
end

% prepare data for wanderlust  (nxd)
data = wdata; % (Nxn)

% set start point
emptys = 0;
if isfield(params,'s')
	emptys = isempty(params.s);
end

% dialog to set startpoint manually
% --- Preparation -----------
alpha = 0.001;
x_data = data; % (nxN) ---------- all data
y_data = cmatrix' * x_data'; % (mxN) -------- measured data
y_data = y_data'; % (mxN) -> (Nxm) 
x_coords = start; % Initial conditions from Toettcher model
y_coords = cmatrix' * x_coords; % IC for measured outputs
y_coords = y_coords'; %
ballsize = range(y_data,1)*alpha; % (mx?)
%ballsize(end)=ballsize(end)*alpha;
%X_Cor = bsxfun(@minus, x_data, x_coords);% x - x_0

Y_Cor = bsxfun(@minus, y_data, y_coords);

y_inball = bsxfun(@lt, (Y_Cor).^2, ballsize);
inball = all(y_inball,2); % 1 = within the ball, 0=not within ball

%-----------------------------
if ~isfield(params,'s') || emptys
    params.s = find(inball);% index to the set of start points
end
% 	rect = [20 20 800 600];
% 	fh= figure('Color','w','Position',rect);
% 	psc = scatter(y_data(:,1),y_data(:,2),'ob');
% 	title('Click on starting point for wanderlust')
% 	xlabel(opts.Ynames(opts.PathIndex(1)))
% 	ylabel(opts.Ynames(opts.PathIndex(2)))
% 	hold on
%     psc = scatter(y_data(inball,1),y_data(inball,2),'or');


% normalize data
if (params.normalize)
	y_data = y_data-repmat(prctile(y_data, 1, 1), size(y_data,1),1);
	y_data = y_data./repmat(prctile((y_data), 99, 1),size(y_data,1),1);
end

% weight the data
y_data = y_data.*repmat(params.wanderlust_weights,size(y_data,1),1);

% compute trajectory
G = wanderlust(y_data,params);

%% Visualize the result
% get mean wanderlust path
G = getMeanWanderlustPath(G,y_data,opts);
end

