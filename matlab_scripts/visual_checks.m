%% Visual checks

for i = randi(n,1);
    figure(i)
    plot(random_statevalues{i})
    xlabel('Time')
    ylabel('AU')
    title('Simulated')
end
