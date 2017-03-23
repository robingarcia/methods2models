%% New script for DNA duplication

function  y = piecewise(time)
% First interval
y(find(0<= time & time < p_g1*T)) = 2;

% Second interval
time2 = time(p_g1*T <= time & time < (p_g1+p_s)*T);
y(find(p_g1*T <= time & time < (p_g1+p_s)*T)) = slope*time2 + 2;

% Third interval
time3 = time((p_g1+p_s)*T <= time & time <= T);
y(find(p_g1+p_s)*T <= time & time <= T) = 4;


