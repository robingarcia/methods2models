function [ fdist ] = distribution_func(a,gamma)
%UNTITLED4 Summary of this function goes here
%   This is our distribution function
%   gamma is the growth rate
%   a is our input variable
fdist=2.*gamma.*exp(-gamma.*a);

end

