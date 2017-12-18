
function  out = sbistPathYDensity(data,bandwidth)

%% Function to generate the joint probability density of the path and readouts
%
%% Inputs
%  - nxN matrix with DAPI and geminin values as the first two rows of the dataset
% sbistExpData_Obj - sbistObj from which data was extracted
% bandwidth - nx1 vector of gaussian kernel bandwidth for each dimension
%
%% Output
% out - struct with y densities
%
[d,N]	= size(data);

datarange = minmax(data);
diffrange = diff(datarange,[],2);
xr = datarange(:,1);
yr = datarange(:,2);

% preallocate variables
Yout = cell(1,d);
y_single_cell = cell(1,d);
f_ypdf_single = cell(1,d);
for i = 1:d
	
	ymu = data(i,:);
	ybw = bandwidth(i).^2;
    
    % much faster if only 1D
	y_fk = @(x) 1/( (2*pi)^(1/2) * (det(ybw))^(1/2) ) .* exp(-0.5/ybw * (bsxfun(@minus,x,ymu)).^2);
	
    Yout{i} = linspace(xr(i)-diffrange(i)/10,yr(i)+diffrange(i)/10 ,200);
	ytestmat = y_fk(Yout{i}');
	y_single_cell{i} = mat2cell(ytestmat,length(Yout{i}),ones(N,1));
	f_ypdf_single{i} = @(y) interp1(Yout{i},ytestmat,y,'linear',eps);  % extrapolation = 0+eps
	
	%% approach with first transformaingand s, then adding y, then summing
	% --> the fastest!!!
	
% 	ay_single_cell3{i} = cellfun(@(a,y) a*y',a_single_cell3,y_single_cell{i},'UniformOutput',0);
% 	ay_all_cells3{i} = sum(cat(3,ay_single_cell3{i}{:}),3).*1/N;
	
end

out.y_single_cell	= y_single_cell;
out.y				= Yout;
out.f_ypdf_single	= f_ypdf_single;
