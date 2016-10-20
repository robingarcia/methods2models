

options.Ynames		= {'DNA','geminin','Cyclin B'};
options.PathIndex	= [1,2];
options.Yindex		= [1,2,3];
options.doplots	= 0;
options.gamma		= log(2)/24;	% population growth rate
% Wanderlust options
 params = [];
 params.l = 8;
 params.k = 15;
 params.num_landmarks = 80;
 params.num_graphs = 30;
 params.metric = 'euclidean';
 params.normalize = true;
 params.band_sample = true;
 params.voting_scheme = 'exponential';
 params.flock_landmarks = 2;
 params.wanderlust_weights = [1,1];		% weights for the dimensions of the dataset used for wanderlust
params.verbose	= false;
options.wanderlust = params;