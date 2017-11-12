function M2M_areaP(BEST)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

d=size(BEST,2); %Determine the dimension

for i=1:d
    %name = BEST{1,i}(:,2);
    %name = [name{:}];
    value = BEST{1,i}(:,5);
    value = [value{:}];
    barh(value);
end

end

