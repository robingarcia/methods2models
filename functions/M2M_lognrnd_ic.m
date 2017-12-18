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
%==========================================================================
%     methods2models
%     Copyright (C) 2017  Robin Garcia Victoria
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%==========================================================================


% Change the IC value log normally distributed
ic_not_zero = (ic ~=0); %31-27
sigma = 1;
M = ic(ic_not_zero);
V = sigma .* M;
MU = log(M.^2 ./ sqrt(V+M.^2));
SIGMA = sqrt(log(V./M.^2 + 1));
% preallocate rndmic and set initial values
rndmic = zeros(length(ic),N);
        for i = 1:N %ICdefault = 0; 
            this_randIC = lognrnd(MU,SIGMA);
            rndmic(ic_not_zero,i) = this_randIC;   
        end
end
