function y = DNA (t,z,q,p_g1, p_s, n)
% Piecewise defined function
% Call y = DNA(t)

%y = 2 .*(t>=0 & t < p_g1*T(:,i));
%y = 2+slope*t .* (t>=p_g1*T(:,i) & t < (p_g1*T(:,i)+p_s*T(:,i)));
%y = 4 .* (t>=(p_g1*T(:,i)+p_s*T(:,i)) & t <= T(:,i));

%Design of vectors
two=[1:length(t)];
two(1:length(t)) = 2;

four=[1:length(t)];
four(1:length(t)) = 2;

p_g1 = 30*0.5; % Duration G1-Phase
p_s = 30*0.3;  %Duration S-Phase
p_g2 = 30*0.16; % Duration G1-Phase
p_gm = 30*0.04; %p_g2 Duration G2-Phase

%y = two .*(t>=0 & t < p_g1.*z);
%y = y + two+q .* (t>=p_g1.*z & t < (p_g1.*z+p_s.*z));
%y = y + four .* (t>=(p_g1.*z+p_s.*z) & t <= z);

%y = two .*(t>=0 & t < p_g1);
%y = y + two+q .* (t>=p_g1 & t < (p_g1+p_s));
%y = y + four .* (t>=(p_g1+p_s) & t <= z);
for i = 1:n;
    y = two .*(t(1,n)>=0 & t(1,n) < p_g1(1,n));
    y = y + two+q(1,n) .* (t(1,n)>=p_g1(1,n) & t(1,n) < (p_g1(1,n)+p_s(1,n)));
    y = y + two .* (t(1,n)>=(p_g1(1,n)+p_s(1,n)) & t(1,n) <= z);
end
end
