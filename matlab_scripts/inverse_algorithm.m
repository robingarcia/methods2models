%% Inverse transformation algorithm (SAS)
% Example of using the inverse CDF algorithm to generate variates from the exponential distribution
rand('seed',12345)
n=1000;
nSamples = n;
 
% BETA PARAMETERS
mu = gamma;

 
% DRAW PROPOSAL SAMPLES
z = rand(1,nSamples); %Create uniform distributed pseudorandom numbers
 
% EVALUATE PROPOSAL SAMPLES AT INVERSE CDF
pd = makedist('exp');
samples = icdf(pd,z);
bins = linspace(0,1,50);
counts = histc(samples,bins);
probSampled = counts/sum(counts);
probTheory = exppdf(bins,mu);
 
% DISPLAY
b = bar(bins,probSampled,'FaceColor',[.9 .9 .9]);
hold on;
t = plot(bins,probTheory/sum(probTheory),'r','LineWidth',2);
xlim([0 1])
xlabel('x')
ylabel('p(x)')
legend([t,b],{'Theory','IT Samples'})
hold off