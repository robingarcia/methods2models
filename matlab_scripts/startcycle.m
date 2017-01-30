%% Start of the cell cycle --> max. APC concentration
filename = uigetfile('~/methods2models/datasets');
datafile = importdata(filename);
load('toetcher_statenames.mat');
x=datafile{1,1};
apc =x(:,6);
startcc = max(apc);
apc_max = max(apc)
apc_min = min(apc)
plot(apc);

%DNA
DNA = @(t) (((x - 2) .* and((x >= 2),(x <= 3))) + ((4 - x) .* and((x >= 3),(x <= 4))));
