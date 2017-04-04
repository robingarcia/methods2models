function [w] = ERA(f,F,alpha)
% The ERA transform
w=alpha*(2-F)./f;