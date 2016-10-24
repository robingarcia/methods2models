
%% Load data

datafolder	= './';
datafile	= 'data.mat';

load(fullfile(datafolder,datafile))
data = newdata';
% load options for ERA and wanderlust
load_options

%% Find a path through the population 
% wanderlust options
start = [-3,-1.2];
startballsize = [0.02,0.02];
wanderlust_weights = [1,1];
doplots = 1;
num_graphs = 30;
PathIndex = [1,2];
manual_path = 0;

G = PathfromWanderlust(data,options);
path = G.y;

%% Plot data and path
figure('Color','w','Position',[50,50,800,600])
plotDataAndPath(data(:,options.PathIndex),path,options);

%% Cell Density on the path

PathDensity = sbistFACS2PathDensity(data,path,options);

%% Transform density to age scale
gamma = log(2)/18;  % growthrate
newScale.pdf = @(a) 2*gamma*exp(-gamma.*a);
newScale.cdf = @(a) 2-2*exp(-gamma.*a);
newScale.coDomain = [0,log(2)/gamma];

NewPathDensity = sbistFACSDensityTrafo(PathDensity,newScale);

options.doplots = 1;
PlotERAVariance(data,NewPathDensity,options)