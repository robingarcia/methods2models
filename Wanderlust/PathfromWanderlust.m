function G = PathfromWanderlust(wdata,opts,start,cmatrix)

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
	params.wanderlust_weights = ones(1,length(opts.PathIndex));
end

% prepare data for wanderlust  (nxd)
%o_data	= wdata(:,opts.PathIndex); % <-- not neccessary because C-matrix
%data	= o_data;
data = wdata; % (Nxn)

% set start point
emptys = 0;
if isfield(params,'s')
	emptys = isempty(params.s);
end

% dialog to set startpoint manually
% --- Preparation -----------
alpha = 0.1;
x_data = data; % (nxN) ---------- all data
y_data = cmatrix * x_data; % (mxN) -------- measured data
y_data = y_data'; %
x_coords = start; % Initial conditions from Toettcher model
y_coords = cmatrix * x_coords; % IC for measured outputs
y_coords = y_coords'; %
ballsize = range(y_data,2)*alpha; % (Nx?)
X_Cor = bsxfun(@minus, x_data, x_coords);% x - x_0
%X_Cor2 = bsxfun(@times, X_Cor.^2, 1./ballsize.^2);
Y_Cor = bsxfun(@minus, y_data, y_coords);

y_inball = bsxfun(@lt, Y_Cor.^2, ballsize);
inball = all(y_inball,1);
%y_inball = sum(X_Cor2,2) <1; %all(y_inball,1);
%-----------------------------
if ~isfield(params,'s') | emptys
	rect = [20 20 800 600];
	fh= figure('Color','w','Position',rect);
	psc = scatter(y_data(:,1),y_data(:,2),'ob');
	title('Click on starting point for wanderlust')
	xlabel(opts.Ynames(opts.PathIndex(1)))
	ylabel(opts.Ynames(opts.PathIndex(2)))
	hold on
    %x_coords = start(1);
%---    for z = 1:size(opts.PathIndex,2)-1 %Without DNA, y_coords = DNA
        %for i = opts.PathIndex(z)
%---    x_coords = start(opts.PathIndex(z)); %All other measurement outputs
%---    y_coords = start(end); %DNA
	%[x_coords,y_coords]  = ginput_ax_mod2(gca,1); % Klick here :3
%---	ballsize = [0.002,0.02];
	%inball = (data(:,1)-x_coords).^2 < ballsize(1) & (data(:,2)-y_coords).^2 < ballsize(2); %n-sphere
%---    X_Cor = bsxfun(@minus, data(:,z),x_coords);
    %X_Cor = bsxfun(@minus, x_data,x_coords);
    %Y_Cor = bsxfun(@minus, y_data, y_coords);
    
%---    inball = (X_Cor).^2 < ballsize(1) & (data(:,end)-y_coords).^2 < ballsize(2); %n-sphere ???!!!
    psc = scatter(data(inball,1),data(inball,2),'or');
	params.s = find(inball);% index to the set of start points
    %end
    end
%end

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

