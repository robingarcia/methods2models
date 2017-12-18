function [y] = M2M_function_temp(expectation,variance)
%UNTITLED3 Summary of this function goes here
%   Curve build with discrete values

n_cells=size(variance,2);
binsize =0.1;
% x = linspace(0,1,n_cells);%Normalized because from 0 to 1

   xwant = linspace(0,1,n_cells);           % Range from 0 to 1
   x_wanderlust = normdata(expectation);    %Expectation value (age)
   y_wanderlust = variance;                 %Variance (age)
   y = moving_average(x_wanderlust,y_wanderlust,xwant,binsize);
%    y = ywant;                               %Wanted datapoints
end

