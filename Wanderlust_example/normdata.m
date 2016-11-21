function [ndata,varargout] = normdata(data,linlog,value)

%% Function norm a dataset between [0,1]
% An axis transformation transfer on the dataset is transformed, such that
% all values of the dataset are between 0 and 1
%
% for linear transformations:
% xnorm = (x - minx) * 1/(maxx - minx)
%
% for additional logarithmic transformations:
% logx = log(x)
% xnorm = (logx - minlogx) * 1/(maxlogx - minlogx)
%
%% Input
% data = 1xn vector
% linlog = optional 'linear' or 'log', default is 'linear'
%
%% Output
%
% ndata = 1xn normed data vector
% fh_forward = function handel for the forward trafo 'ndata = fh_forward(data)'
% fh_backward = function handel for the backward trafo 'data = fh_backward(ndata)'


%% Parse input

trafotype = 'linear';

if nargin >= 2
	trafotype = linlog;
end

datasize = size(data);
vdata = data(:);
datalength = length(vdata);

dmin = min(vdata);
dmax = max(vdata);

%% Do the transformtion

switch trafotype
	case 'linear'
		fh_fw	= @(x) (x-dmin) / (dmax-dmin);
		fh_bw	= @(x) x * (dmax-dmin) + dmin;
	case 'log'
		fh_fw1	= @(x) (x-log(dmin)) / (log(dmax)-log(dmin));
		fh_fw	= @(x) fh_fw1(log(x));
		fh_bw1	= @(x) exp(x);
		fh_bw	= @(x) fh_bw1(x * (log(dmax)-log(dmin)) + log(dmin));
	case 'linear_onlymax'
		fh_fw	= @(x) x / dmax;
		fh_bw	= @(x) x * dmax;
	case 'log_onlymax'
		fh_fw1	= @(x) x/log(dmax);
		fh_fw	= @(x) fh_fw1(log(x));
		fh_bw1	= @(x) exp(x);
		fh_bw	= @(x) fh_bw1(x * log(dmax));
	case 'log_only'
		fh_fw	= @(x) log(x);
		fh_bw	= @(x) exp(x);
	case 'notrafo'
		fh_fw	= @(x) x;
		fh_bw	= @(x) x;
	case 'linear_value'
		fh_fw	= @(x) x.*value;
		fh_bw	= @(x) x./value;
	case 'log_value'
		fh_fw	= @(x) log(x*value);
		fh_bw	= @(x) exp(x)/value;
	case 'linear_mean'
		fh_fw	= @(x) x./mean(x).*value;
		fh_bw	= mean(vdata);
	case 'log_mean'
		fh_fw	= @(x) log(x) - log(mean(x)) + value;
		fh_bw	= mean(vdata);
	otherwise
		error('Wrong transformation type: %s',linlog)
end

nldata = fh_fw(vdata);
ndata = reshape(nldata,datasize);

% Function handles for forward and backward trafo
varargout{1} = fh_fw;
varargout{2} = fh_bw;
