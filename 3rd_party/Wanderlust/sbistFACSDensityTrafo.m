function NewPathDensity = sbistFACSDensityTrafo(PathDensity,newScale)

%% Function for the transformation of pdfs to a desired pdf
% 
%
%% Inputs
% PathDensity		- output from sbistFACS2PathDensity
% newScale			- struct with info for the new scale
% 				+ @(a) pdf(a) (function handle)
%				+ @(a) cdf(a) (function handle)
%				+ [low,up] co-domain of a 

%% Output
% NewPathDensity - new path density struct with new scale densities


a_pdf = newScale.pdf;
a_cdf = newScale.cdf;
codom = newScale.coDomain;

% make struct variables easy accesible
v2struct(PathDensity)
% s_single_cell:				{1x2000 cell}
% s:							[100x1 double]
% f_spdf:						@(s)interp1(Sout,spdf,s)
% f_spdf_single:				@(s)interp1(Sout,testmatnormed,s)
% f_scdf:						@(s)interp1(Sout,scdf,s)
% f_scdf_inv:					@(x)interp1(scdf,Sout,x)
% f_sdpdf:						@(s)interp1(Sout,sdpdf,s)
% N:							2000
% s_single_cell_Expectation:	{1x2000 cell}
% s_single_cell_Variance:		[1x2000 double]


% prefactor for pdf trafo to conserve the area under the curve
tau_inv   = @(a) f_scdf_inv( a_cdf(a));

prefactor = @(a) a_pdf(a) ./ (  f_spdf( tau_inv(a)));


Aout = interp1(tau_inv(linspace(codom(1),codom(2),1000)),linspace(codom(1),codom(2),1000),s);

myPrefactors = prefactor(Aout);

f_apdf_single = @(a) bsxfun(@times,f_spdf_single(tau_inv(a))',prefactor(a))';

a_single_cell = cellfun(@(x) x.*myPrefactors,s_single_cell,'UniformOutput',0);
a_all_cells = sum(cat(3,a_single_cell{:}),3).*1/N; %Area under curve



%% Variance in a of my datapoints

calculateExpectation = @(x,p) trapz(x,x.*p);
calculatedVariance = @(x,p,mu) trapz(x,p.*(x-mu).^2);


a_single_cell_Expectation = cellfun(@(p) calculateExpectation(Aout,p),a_single_cell,'UniformOutput',0);
a_single_cell_Variance = cellfun(@(p,mu) calculatedVariance(Aout,p,mu),a_single_cell,a_single_cell_Expectation);

% if doplots
% 	rect = [20 20 800 600];
% 	fh = figure('Color','w','Position',rect);
% 	scatter(data(opts.PathIndex(1),:),data(opts.PathIndex(2),:),8,a_single_cell_Variance)
% 	colormap('copper')
% 	shading interp
% 	xlabel(opts.Ynames{opts.PathIndex(1)})
% 	ylabel(opts.Ynames{opts.PathIndex(2)})
% 	title('Variance in age of single datapoints (no noise)')
% end

%% Write the data to the output struct

NewPathDensity = PathDensity;

NewPathDensity.a = Aout;
NewPathDensity.a_single_cell = a_single_cell;
NewPathDensity.a_all_cells = a_all_cells;
NewPathDensity.f_apdf_single = f_apdf_single;


NewPathDensity.f_TauInv	= tau_inv;
NewPathDensity.f_prefactor = prefactor;

NewPathDensity.a_single_cell_Expectation	= a_single_cell_Expectation;
NewPathDensity.a_single_cell_Variance	= a_single_cell_Variance;


