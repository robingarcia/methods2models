function fh = plotDataAndPath(data,apath,opts,figpath,opt_only_path,lineopts)

%% Function to plot a path in a dataset
%
% 
%% Inpt
%
% apath		- dxp  > p datapoints of the d dimensional path
% data		- nxd data
%
%% Output
%
% fh		- figure handle

y = data;
[n,d] = size(y);

if (nargin > 2) && (isfield(opts,'Ynames') && isfield(opts,'PathIndex'))
	dimension_names = opts.Ynames(opts.PathIndex);
else
	dimension_names = sprintfc('dim %i',1:d);
end

only_path = 0;
if (nargin>3) && ~isempty(opt_only_path)
    only_path = opt_only_path;
end



myopts = {'LineStyle', '-'};
if (nargin>4) 
    myopts = lineopts;
end

% subplot layout
% possible combinations of dimensions in 2d
C = nchoosek(1:d,2);
a = floor(size(C,1)^(1/2));
b = ceil(size(C,1)/a);

for i = 1:size(C,1)
    if size(C,1) > 1
        subplot(a,b,i)
    end
    if ~only_path
	[~,dens,X,Y] = kde2d(data(:,C(i,:)),2^6);
	pcolor(X,Y,dens); shading interp							% density
	hold on
	scatter(figpath,data(:,C(i,1)),data(:,C(i,2)),1,'w.')				% all datapoints 
    end
    
    if ~isempty(apath)
        plot(figpath,apath(C(i,1),:),apath(C(i,2),:),'r','LineWidth',3,myopts{:})		% path
    end
    hold on
	xlabel(dimension_names{C(i,1)})
	ylabel(dimension_names{C(i,2)})
end

fh =gcf;