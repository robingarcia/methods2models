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
find_zero = find(data(:,1)==0);
find_nzero = find(data(:,1)~=0);
data(find_zero,:)=[];
end

