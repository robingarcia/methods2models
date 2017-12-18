function M2M_twocomboP(best_area,best_name,statenames)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

sizeof = size(best_area,1);%Determine size
voi = 1:sizeof; %Vector of interest
delimi=round(351/10);%Numerical Delimiter
j = voi(1:delimi:end); %Only every 35th element, show only 10 bars
% bar(best_area(j,1));
for i=j
   testname=statenames(best_name{i,1});
   testname=strjoin(testname,'/');
   testname=cellstr(testname);
   
   name=categorical(testname);
   area=best_area(i,1);
%    value=categorical(area);
   bar(name,area)
%   bar(area)
   hold on
%    bar(value,area)
end
end

