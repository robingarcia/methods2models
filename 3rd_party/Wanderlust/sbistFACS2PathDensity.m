
function PathDensity = sbistFACS2PathDensity(data,path_coordinates,opts)

%% Function to construct a density of flow datapoints along a given path
% bla
%
%% Inputs
% data				- nxd matrix with of the d-dimensional flow dataset with Events
% path_coordinates	- dxp matrix of p points on the path_curve or G struct from wanderlust
% opts				- options
%
%% Output
% PathDensity - ERA-results struct for ERA without noise
%



%% Check Inputs
fs = 12; % Font size
% gaussbandwidth = [0.000653,0.0049];
% data_DAPI_Gemini  = data(opts.PathIndex,:);
%data = cmatrix * data';
%data = data'; % dxn -> nxd Correct?
[n,d]	= size(data);

% Do Plots  (default = 1)
if isfield(opts,'doplots')
	doplots = opts.doplots;
else
	doplots =1;
end

% Do Y IDs  (default = all)
if isfield(opts,'yIndex')
	yID = opts.yIndex;
else
	yID = 1:size(data,2);
end

% Do Y IDs  (default = all)
if isfield(opts,'path_weights')
	path_weights = opts.path_weights;
else
	path_weights = ones(size(opts.PathIndex));
end

% if path bandwidth (h) is given, then use that else calculate
if isfield(opts,'path_bandwidths')
	gaussbandwidth = opts.path_bandwidths;
else
	% find rigth bandwidths in the different dimensions and take the mean
	bws = zeros(d,d);
    %I = find_nan;
    %J = find_nan;
    if d==1
        gaussbandwidth = kde(data);
    else
        for i=1:d
            %if i ~= I
            for j=1:d
                
                bandwidth = kde2d([data(:,i),data(:,j)]);   % Nx2? 2D -> nD?
                bws(i,j) = bandwidth(1);
                %else
                %end
                
            end
            %else
            %end
        end
        gaussbandwidth = mean(bws,2);
    end
end

% Number of grid points in path scale and thus also transformed scale
if isfield(opts,'n_path_grid')
	n_path_points = opts.n_path_grid;
else
	n_path_points = 200;
end

PathDensity =[];

%% If Wanderlust provided, 
% then generate single cell contribution to the path with the output from
% wanderlust by useing the ksdensity function on all trajactories from
% wanderlust for each single datapoint
n_path_points = 200; %Why 200?
Sout = linspace(0,1,n_path_points)';
if isstruct(path_coordinates)
	G = path_coordinates;
	% normalize G.T
	normGT = bsxfun(@times,(bsxfun(@minus,G.T,min(G.T')')), 1./(max(G.T')'- min(G.T')'));
	nT = size(normGT,1);
	Sigma = 0.01;
	% loop over each cell
	testmat = zeros(n_path_points,N);
	parfor i = 1:N
		onecell = zeros(nT,n_path_points);
		for j = 1:nT
			 fh_onecell = @(x) exp(-0.5./Sigma^2 * (x-normGT(j,i)).^2 )./(2*pi*Sigma)^(1/2);
			 onecell(j,:) = fh_onecell(Sout) + fh_onecell(-Sout) + fh_onecell(2-Sout);  % flip booundaries around
		end
		testmat(:,i) = sum(onecell);
% 		[testmat(:,i),~] = ksdensity(normGT(:,i),Sout,'kernel','normal','support',[0-eps,1+eps]);
% 		p = gkdeb(normGT(:,i),p);
% 		[bandwidth,density,xmesh] = kdem(normGT(:,i),512,0-eps,1+eps);
	end	
else
%% Find the the closest point on the curve for each datapoint
% This is done to generate the numberdensity along the path
% The functions distance2curve and arclength will be used.
% new method to get the pdf with probability density of each datapoint on s
% function handle for each gaussian (taken from p_dimensional_Gaussian2)

% [1:length(opts.PathIndex)] <-- length of opts.PathIndex for position!
% mu = data(:,[1:length(opts.PathIndex)]);
% Sigma = diag(gaussbandwidth([1:length(opts.PathIndex)]).*path_weights').^2;
mu = data;
Sigma = diag(gaussbandwidth(:).*path_weights(:)).^2;
% [fh,jh,hh,fk,jk,hiik] = p_dimensional_Gaussian2(mu,Sigma,0);
fk = @(x) 1/( (2*pi)^(d/2) * (det(Sigma))^(1/2) ) .* arrayfun(@(n) exp(-0.5 * (x-mu(n,:)')' * (Sigma\(x-mu(n,:)')) ),1:n);

% function to get x coordinates dependent on s for the evaluation of gaussion on s
% remove doublicates in the path coordinates
% if any(isnan(path_coordinates)) %<-- from me
nan_coordinates = any(isnan(path_coordinates),1);%nxm n = outputs, m=100
path_coordinates = path_coordinates(:,~nan_coordinates);
% path_coordinates(isnan(path_coordinates))=[];
% path_coordinates = path_coordinates(:,nan_coordinates);%<-- from me
% else
% end
path_coordinates(:,all(path_coordinates(:,(1:end-1)')==path_coordinates(:,(2:end)'))) = [];

if size(path_coordinates,1)<2
    Sin  = (path_coordinates'-min(path_coordinates) )./range(path_coordinates);
else
    path_cell = num2cell(path_coordinates,2);
    [len,seglen] = arclength(path_cell{:});
    Sin = [0; cumsum(seglen)] / len;
end

% linear interpolation with my function
% [Xout] = mySpaceCurveInterpolation(path_coordinates,Sin,Sout);
%fh_coords = @(s) mySpaceCurveInterpolation(path_coordinates,Sin,s);

% interpolation with pchip
try
    pp = pchip(Sin',path_coordinates); %Error here because NaN!
    fh_coords = @(s) ppval(pp,s);
catch
    warning('Fehler')
end

% for fast parfor computation
s_coords  = num2cell(fh_coords(Sout),1);
test = cell(n_path_points,1);

if size(path_coordinates,1)<2
    parfor i = 1:n_path_points
        test{i} = fk(s_coords{1}(i))';
    end
else
    parfor i = 1:n_path_points
        test{i} = fk(s_coords{i})';
    end
end
testmat = [test{:}]';%Zero? But why??????

% set to uniform distribution if all are zero
allzero = (testmat == 0);
testmat(allzero) = eps(0);
if any(allzero)
   warning('There are %i points with zero density',sum(allzero(:))) 
end

end
% weights for each datapoint test is the contribution of each single datapoint
% as density on s 
weights = trapz(Sout,testmat*1000);%w;
testmatnormed1 = log(testmat) + log(1000); 
testmatnormed2  = bsxfun(@plus,testmatnormed1, -log(weights));
testmatnormed = exp(testmatnormed2);

s_single_cell = mat2cell(testmatnormed,length(Sout),ones(n,1));

fh_spdf_single = @(s) interp1(Sout,testmatnormed,s,'linear',eps);

pdfpoints = sum(testmatnormed,2);%Sometimes NaN. But why?

% function handles to the pdf, cdf and derivative of pdf
spdf = pdfpoints ./ trapz(Sout,pdfpoints);
fh_spdf = @(s) interp1(Sout,spdf,s,'linear',eps);%Linear?

scdf = arrayfun(@(s) integral(fh_spdf,0,s),Sout);
scdf([1,end]) = [0,1]; %Probability
fh_scdf = @(s) interp1(Sout,scdf,s);

sdpdf = gradient(spdf,diff(Sout(1:2)));
fh_sdpdf = @(s) intfh_coordserp1(Sout,sdpdf,s,'linear','extrap');% linear?

%

fh_scdf_inv = @(x) interp1(scdf,Sout,x,'linear','extrap');%Linear?

%% Variance in a of my datapoints

calculateExpectation = @(x,p) trapz(x,x.*p);
calculatedVariance = @(x,p,mu) trapz(x,p.*(x-mu).^2);


s_single_cell_Expectation = cellfun(@(p) calculateExpectation(Sout,p),s_single_cell,'UniformOutput',0);
s_single_cell_Variance = cellfun(@(p,mu) calculatedVariance(Sout,p,mu),s_single_cell,s_single_cell_Expectation);

% if doplots
% %subplot layout
%  C = nchoosek(1:d,2); %WChooseK ? 
%  a = floor(size(C,1)^(1/2));
%  b = ceil(size(C,1)/a);
% length_PathIndex=length(opts.PathIndex);
% 	rect = [20 20 800 600];
% 	fh = figure('Color','w','Position',rect);
%     for i = 1:length_PathIndex-1%opts.PathIndex(end-1)
%          subplot(a,b,i)
%          hold on
% 	f(i)=scatter(data(:,i),data(:,length_PathIndex(end)),8,[s_single_cell_Expectation{:}]);
% 	colormap('bone')
% 	hold on
% 	%[bandwidth,density,X,Y] = kde2d(data(:,opts.PathIndex(1:2))');
%     [bandwidth,density,X,Y] = kde2d(data(:,C(i,:)));%opts.PathIndex(1:2),:)');
% 	pcolor(X,Y,density)
% 	colormap('parula')
% 	shading interp
% 	xlabel(opts.Ynames{opts.PathIndex(i)})
% 	ylabel(opts.Ynames{opts.PathIndex(end)})
% 	title('Data with position')
%     end
% end

%% Write the data to the output struct

PathDensity.s_single_cell	= s_single_cell;
PathDensity.s				= Sout;
PathDensity.f_spdf			= fh_spdf;
PathDensity.f_spdf_single	= fh_spdf_single;
PathDensity.f_scdf			= fh_scdf;
PathDensity.f_scdf_inv		= fh_scdf_inv;
PathDensity.f_sdpdf			= fh_sdpdf;
PathDensity.bandwidth		= gaussbandwidth;

PathDensity.N			= n;

PathDensity.s_single_cell_Expectation	= s_single_cell_Expectation;
PathDensity.s_single_cell_Variance	= s_single_cell_Variance;



