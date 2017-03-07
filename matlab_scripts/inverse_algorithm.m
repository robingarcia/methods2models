%% Inverse transformation algorithm (SAS)
% Example of using the inverse CDF algorithm to generate variates from the exponential distribution
rand('seed',12345)
nSamples = n;
 
% BETA PARAMETERS
gamma;
 
% DRAW PROPOSAL SAMPLES
z = rand(1,nSamples);
 
% EVALUATE PROPOSAL SAMPLES AT INVERSE CDF
samples = icdf('beta',z,alpha,beta);
bins = linspace(0,1,50);
counts = histc(samples,bins);
probSampled = counts/sum(counts)
probTheory = betapdf(bins,alpha,beta);
 
% DISPLAY
b = bar(bins,probSampled,'FaceColor',[.9 .9 .9]);
hold on;
t = plot(bins,probTheory/sum(probTheory),'r','LineWidth',2);
xlim([0 1])
xlabel('x')
ylabel('p(x)')
legend([t,b],{'Theory','IT Samples'})
hold off