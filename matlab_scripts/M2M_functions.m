function [y,f] = M2M_functions(summary,ic,N,snaps)
% This function creates function handles for your datapoints 
% 
% 
% [Syntax]
% [y,f] = M2M_functions(summary,ic,N,snaps)
% 
% [INPUT]
% summary:          struct: Contains variances of all cells
% ic:               number: Initial conditions
% N:                number: Number of cells
% snaps:            number: Number of snapshots
% 
% [OUTPUT]
% y:                number: New datapoints
% f:                cell:   function handles for every species
%
% [EXAMPLE]
% Pending
f = cell(1,size(ic,1));
binsize =0.1;
x = linspace(0,1,N*snaps);
y = zeros(size(ic,1),N*snaps); % Functions of all species
for i = 1:size(ic,1)           %For all 27 species
   xwant = linspace(0,1,size(summary.a_Est(i,:),2));
   x_sum = normdata(summary.a_Est(i,:));
   y_sum = summary.Var_a(i,:);
   ywant = moving_average(x_sum,y_sum,xwant,binsize);
   f{i} = griddedInterpolant(xwant,ywant,'cubic');% f = function
   y(i,:) = f{i}(x);%Calculate the function
end
end

