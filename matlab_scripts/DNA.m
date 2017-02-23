function y = DNA (t,z,q, n, apc)
% Piecewise defined function
% Call y = DNA(t)

%Design of vectors
two=[1:length(t)];
two(1:length(t)) = 2;

four=[1:length(t)];
four(1:length(t)) = 4;
length_apc = length(apc);

a = [1:length(t)];
b = [1:length(t)];
c = [1:length(t)];

%times=t(

for i = 1:length_apc;
    p_g1(1,i) = apc(1,i)*0.5; % Duration G1-Phase
    p_s(1,i) = apc(1,i)*0.3;  %Duration S-Phase
    p_g2(1,i) = apc(1,i)*0.16; % Duration G1-Phase
    p_gm(1,i) = apc(1,i)*0.04; %p_g2 Duration G2-Phase

a=two ((t>=2) & (t < p_g1))
b=two((t>=p_g1) & (t < (p_g1+p_s)))
c=four((t>=(p_g1+p_s)) & (t <= z))
    
y=[a,b,c]
figure(55)
hold on;
plot(y);
end
end
