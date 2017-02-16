function y = DNA (t_3,z,q,p_g1, p_s)
% Piecewise defined function
% Call y = DNA(t)

%y = 2 .*(t>=0 & t < p_g1*T(:,i));
%y = 2+slope*t .* (t>=p_g1*T(:,i) & t < (p_g1*T(:,i)+p_s*T(:,i)));
%y = 4 .* (t>=(p_g1*T(:,i)+p_s*T(:,i)) & t <= T(:,i));

%Design of vectors
two=[1:length(q)];
two(1:50) = 2;

four=[1:length(q)];
four(1:50) = 4;

y = two .*(t_3>=0 & t_3 < p_g1.*z);
y = two+q*t_3 .* (t_3>=p_g1.*z & t_3 < (p_g1.*z+p_s.*z));
y = four .* (t_3>=(p_g1.*z+p_s.*z) & t_3 <= z);
end
