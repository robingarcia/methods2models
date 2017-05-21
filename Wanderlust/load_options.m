

options.Ynames		= statenames;
options.PathIndex	= [1 2]; %input('Input your vector (e.g: [1 2]):')
options.Yindex		= [1:length(statenames)];
options.doplots	= 0;
options.gamma		= log(2)/mean(t_period(1,:));%24;	% population growth rate (ADAPT IT!!!)
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
 params.wanderlust_weights = ones(1,length(options.PathIndex));		% weights for the dimensions of the dataset used for wanderlust
 params.verbose	= false;
options.wanderlust = params;
