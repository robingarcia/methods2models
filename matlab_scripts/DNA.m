function y = DNA(t,T,slope)
% Piecewise defined function
% Call y = DNA(t)

y = 2 .*(t>=0 & t < p_g1*T(:,i));
y = 2+slope*t .* (t>=p_g1*T(:,i) & t < (p_g1*T(:,i)+p_s*T(:,i)));
y = 4 .* (t>=(p_g1*T(:,i)+p_s*T(:,i)) & t <= T(:,i));
end
