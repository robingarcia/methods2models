function [rndmic] = M2M_lognrnd_ic(N,ic)
% Function for the generation of normal distributed initial conditions.
% Usually cells are asynchonous. To simulate realistic behaviour 
% the initial conditions will be randomised.
% 
%   [SYNTAX]
%   [rndmic,ICdefault] = lognrnd_ic(n,ic)
%
%   [Inputs]
%   n                - Number of cells
%   ic               - Initial conditions
%
%
%   [Outputs]
%   rndmic           - Gaussian distributed initial conditions
%   ICdefault        - Default initial conditions
%--------------------------------------------------------------------------

% Change the IC value log normally distributed
ic_not_zero = (ic ~=0); %31-27
sigma = 1;
M = ic(ic_not_zero);
V = sigma .* M;
MU = log(M.^2 ./ sqrt(V+M.^2));
SIGMA = sqrt(log(V./M.^2 + 1));
% preallocate rndmic and set initial values
%rndmic = cell(1,N);
rndmic = zeros(length(ic),N);
%this_randIC = zeros(length(ic)-4,1);

%[rndmic{:}] = deal(zeros(size(ic)));
        for i = 1:N %ICdefault = 0; 
            this_randIC = lognrnd(MU,SIGMA);
            %rndmic{i}(ic_not_zero) = this_randIC;
            rndmic(ic_not_zero,i) = this_randIC;   
        end
end
