%% New script for DNA duplication

function  y = piecewise(time,T)
slope = (2/(30*0.3));
% First interval
y(find(0<= time & time < 0.5*T)) = 2;

% Second interval
time2 = time(0.5*T <= time & time < (0.5+0.3)*T);
y(find(0.5*T <= time & time < (0.5+0.3)*T)) = 2+(slope*time2);

% Third interval
time3 = time((0.5+0.3)*T <= time & time <= T);
y(find(0.5+0.3)*T <= time & time <= T) = 4;


