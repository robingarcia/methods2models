function M2M_lognrnd_icP(rndmic,statenames)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
%% Histogram of the different ICs
ip = [2,3,5,12]; %[1,2,3,4,5,6,7,11,12];
a = floor(size(ip,2)^(1/2));
b = ceil(size(ip,2)/a);

% Loop counter
sum=0;

    while(sum <size(ip,2))

        for i = ip
        sum = sum + 1;
        disp(sum)
        subplot(b,a,sum)
        histogram(rndmic(i,:),2000);

        title(statenames(i))
        xlabel('Concentration (a.u.)')
        ylabel('Number of cells')
        xlim([0 1])
        end
    end
end

