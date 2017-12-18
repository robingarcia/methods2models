%% Cell cylce start
% plot(original_statevalues([1,2,3,5],:))
for i = [1,2,3,5,7,12]
% plot(original_statevalues(i,1:90),'LineWidth', 2.5)
% plot(original_statevalues(i,1:end),'LineWidth', 2.5)
plot(statevalues(1:end,i),'LineWidth', 2.5)
% findpeaks(original_statevalues(i,1:90))
hold on
end
i=[1,2,3,5,7,12];
legend(statenames(i))

%% Plot
for i = [12,1,2,3,5]
% findpeaks(statevalues(:,i));%Cdc20A
plot(statevalues(:,i),'LineWidth',4);%Cdc20A
hold on
end

%% Plateau detection
plot(statevalues(:,12).*-1,'LineWidth',4);%Cdc20A
pbool = (statevalues >= 