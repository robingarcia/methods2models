function [data,find_zero,find_nzero] = M2M_purge(data)
% This function deletes all zero columns 
% 
% 
% [Syntax]
% [data,find_zero,find_nzero] = M2M_purge(data)
% 
% [INPUT]
% data:               number: data with zero columns 
% 
% [OUTPUT]
% data:               number: data without zero columns
% find_zero:          number: ?
% find_nzero:         number: ?
%
% [EXAMPLE]
% Pending
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
find_zero = find(data(:,1)==0);
find_nzero = find(data(:,1)~=0);
data(find_zero,:)=[];
end

