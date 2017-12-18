function [errordata] = M2M_error_model(mydata,sig)
%Error model for protein quantification
%This function introduce noise into our dataset.
% 
% [SYNTAX]
% [errordata] = M2M_error_model(mydata,sig)
% 
% [INPUT]
% mydata:         number: Your dataset
% sig:            number: Sigma
% 
% [OUTPUT]
% errordata:      number: Dataset with noise
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
epsilon = exp(randn(size(mydata))*sig);
errordata =mydata .* epsilon;
end
