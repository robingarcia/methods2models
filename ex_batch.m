%% Submit batch job
addpath(genpath('~/methods2models/'));
clust=parcluster('local');
N=2; % for a quad-core computer
job = batch(clust, @m2m, 1, {0:2000,1000,2,0.01,'model_toettcher2008MEX',0}, 'Pool', N-1);

%% Query state of the job
disp(get(job,'State'))


%% Retrieve and process results
wait(job(end));
if getReport(job.Tasks(1).Error)
   disp(getReport(job.Tasks(1).Error))
   job = batch(clust, @m2m, 1, {0:2000,1000,2,0.01,'model_toettcher2008MEX',0}, 'Pool', N-1);
else
   results= fetchOutputs(job);
   disp(results)
end
% a= results{1};
% hist(a)

%% Delete job
% delete(job)
exit;
