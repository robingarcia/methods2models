function [ub,lb,period] = M2M_start(statevalues)
%This function determines the start of the cell cycle
%   Detailed explanation goes here
mydesire=statevalues(12,1:end);%12th column
find_result = find(mydesire<10^-3); %Find all values smaller than 10e-3
con=find_result(diff(find_result)==1);
zeroos=diff(con)==1;
plateaucorner=find(zeroos == 0);
cornerposition = plateaucorner+1;
position2=con(cornerposition);

period = position2(end)-position2(end-1); %Cell cycle period
ub = position2(end); %upper bound
lb = position2(end-1);%lower bound
end
