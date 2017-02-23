% Piecewise defined function
% Call y = DNA(t)
clear;
clc;
t = 2:32; %This is the APC period
z = 30;
%Design of vectors
two=[1:length(t)];
two(1:length(t)) = 2;

four=[1:length(t)];
four(1:length(t)) = 4;

y = zeros(1,length(t));
y(1:length(t))=2;
%t(t < p_g1)=2



p_g1 = 30*0.5; % Duration G1-Phase
p_s = 30*0.3;  %Duration S-Phase
p_g2 = 30*0.16; % Duration G1-Phase
p_gm = 30*0.04; %p_g2 Duration G2-Phase

slope = abs(2/(p_g2 - p_g1));

a=two ((t>=2) & (t < p_g1)); 
b=two((t>=p_g1) & (t < (p_g1+p_s)));
%for i = 1:length(b);
   %b(:,i) = b(:,i+1)+slope 
%end
c=four((t>=(p_g1+p_s)) & (t <= z));
    
y=[a,b,c]
figure(55)
hold on;
plot(y);
