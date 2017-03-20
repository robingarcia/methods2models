function [ y_DNA ] = DNAcontent(time,T )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
interval = size(time);
time = (1:interval(end));
two=(1:length(time));
two(1:length(time)) = 2;

four=(1:length(time));
four(1:length(time)) = 4;

for k = 1:length(T)
    z = T(k,1);
p_g1 = z*0.5; % Duration G1-Phase
p_s = z*0.3;  %Duration S-Phase
%p_g2 = z*0.16; % Duration G1-Phase
%p_gm = z*0.04; %p_g2 Duration G2-Phase
%slope = abs(2/(p_g2 - p_g1));
t_1 = z/2;
t_2 = 0.8*z;
slope = (2/(t_2 - t_1));

slpe = (length(time>=p_g1):length(time<(p_g1+p_s)));
%slpe(1:length(time)) = 2;
slpe = slope.*time;
%slpe = two+slpe;


a=two((time>=0) & (time < p_g1)); 
b=slpe((time>=p_g1) & (time < (p_g1+p_s)));
c=four((time>=(p_g1+p_s)) & (time <= z));
    
y_DNA=[a,b,c];

end

