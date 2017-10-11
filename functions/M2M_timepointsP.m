function M2M_timepointsP(p_value,samples)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here

scatterhist(p_value(:,1),samples(:,1))

scatter(p_value(:,1),samples(:,1))
hold on
scatter(p_value(:,2),samples(:,2))
end

