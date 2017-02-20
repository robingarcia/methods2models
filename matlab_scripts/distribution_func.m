function [ fdist ] = distribution_func(T,gamma)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
fdist=2*gamma.*exp(-gamma.*T);

end

