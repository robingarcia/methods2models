function [cmatrix] = cmatrix_test(errordata,j)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

species=1:size(errordata,1)-1; %Without DNA
C=WChooseK(species,j);
end

