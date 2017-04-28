function [rndmic,ICdefault] = lognrnd_ic(n,ic)
%lognrnd_ic generates normal distributed initial conditions.


ICdefault = ic;
% Change the IC value log normally distributed
IC_not_zero = (ICdefault ~=0); %31-27
sigma = 1;
M = ICdefault(IC_not_zero);
V = sigma .* M;
MU = log(M.^2 ./ sqrt(V+M.^2));
SIGMA = sqrt(log(V./M.^2 + 1));
% preallocate rndmic and set initial values
rndmic = cell(1,n);
[rndmic{:}] = deal(zeros(size(ICdefault)));
        for i = 1:n %ICdefault = 0; 
            this_randIC = lognrnd(MU,SIGMA);
            rndmic{i}(IC_not_zero) = this_randIC;
        end
end
