toettcher2008 = IQMmodel('model_toettcher2008.txt');
toettcher2008sim = IQMsimulate(toettcher2008,120);
ICdefault = IQMinitialconditions(toettcher2008);
[parameters,values]=IQMparameters(toettcher2008);
Pdefault = values;

IC_not_zero = ICdefault(ICdefault ~=0);
sigma = 1;
M = ICdefault;
V = sigma .* ICdefault;
MU = log(M.^2 / sqrt(V+M.^2));
SIGMA = sqrt(log(V./M.^2 + 1));
[M,V] = lognstat(MU,SIGMA);

L = length(ICdefault);
%gaussIC = zeros(1,27);


for i = 1:L %ICdefault = 0;        
        IC_not_zero = lognrnd(MU,SIGMA);
        rndmic{i} = IC_not_zero;
        %results_mex=model_toettcher2008mex(0:120, gaussIC, Pdefault);
end

