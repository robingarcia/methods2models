

options.Ynames		= statenames;
disp('1 = Cycd  11 = Cdc20i     21 = TFB  31 = TriE21  ')
disp('2 = CycA  12 = Cdc20A     22 = TFBi 32 = DNA')
disp('3 = CycB  13 = Cdk1       23 = TFE')
disp('4 = pB    14 = Cdk1i      24 = TFEi')
disp('5 = CycE  15 = TriA       25 = TFI')
disp('6 = APC   16 = TriE       26 = TFIi')
disp('7 = APCP  17 = Wee1       27 = p21')
disp('8 = CKI   18 = Wee1i      28 = TriD21')
disp('9 = BCKI  19 = Cdc25      29 = TriA21')
disp('10= pBCKI 20 = Cdc25i     30 = TriB21')
options.PathIndex	= input('Input your vector (e.g: [1 2]):')
options.Yindex		= [1:length(statenames)];
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
