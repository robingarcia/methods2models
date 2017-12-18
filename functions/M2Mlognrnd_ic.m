function [rndmic] = M2Mlognrnd_ic(ic)
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
ICdefault = ic;
% Change the IC value log normally distributed
IC_not_zero = (ICdefault ~=0); %31-27
sigma = 1;
M = ICdefault(IC_not_zero);
V = sigma .* M;
MU = log(M.^2 ./ sqrt(V+M.^2));
SIGMA = sqrt(log(V./M.^2 + 1));
            this_randIC = lognrnd(MU,SIGMA);
            rndmic(IC_not_zero) = this_randIC;
            rndmic=rndmic';
end
