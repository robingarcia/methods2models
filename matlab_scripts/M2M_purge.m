function [data,find_zero,find_nzero] = M2M_purge(data)
%This function delete all zero columns
%   Detailed explanation goes here
%ic(ic==0)=[]
find_zero = find(data(:,1)==0);
find_nzero = find(data(:,1)~=0);
data(find_zero,:)=[];
end

