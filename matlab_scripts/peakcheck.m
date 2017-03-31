%% Peakcheck first simulation
for i = randi(n,1) %1:n 
    figure%(i)
    for j = [2,3,4,5,6,7,12]
    ax(1)=subplot(2,1,1);
    findpeaks(random_statevalues{1,i}(:,j))
    xlabel('Time')
    ylabel('AU')
    title('Simulated')
    hold on;
    end
    
    for j = [2,3,4,5,6,7,12]
    ax(2)=subplot(2,1,2);
    findpeaks(measurement{1,i}(j,:))
    %findpeaks(mydata(j,:))
    xlabel('Time')
    ylabel('AU')
    title('Measurement')
    hold on; 
    end
    %figure(1000+i)
    %for j = [2,3,4,5,6,7,12]
    %subplot(2,2,2), findpeaks(measurement{1,i}(j,:))
    %    hold on;
    %end
    
end

%% Peakcheck measurement
%for i = randi(n,1)
%    figure(i)
%    for j = [2,3,4,5,6,7,12,32]
%        findpeaks(measurement{1,i}(j,:))
%        hold on;
%    end
%end
