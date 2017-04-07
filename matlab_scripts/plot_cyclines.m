%% Plot all Cyclines

 for i = 1:n
 j = [2,3,5,6,7];
 combos = nchoosek(j,2);
 r = length(combos);
 f = gobjects(1,r);
 for q=1:r
 figure(2)
 hold on;
 subplot(3,4,q)
 f(q)=plot(random_statevalues{1,i}(:,combos(q,1)),random_statevalues{1,i}(:,combos(q,2)), 'k.');
 hold on;
 for i = 1:n %Plot the start of the cell cycle
     startpoint = START{2,i}; % {2,6} = Localization of the APC-peak
     lstartpoint = length(startpoint);
     for k = 1:lstartpoint
 f(q)=plot(random_statevalues{1,i}(startpoint(k,1),combos(q,1)),random_statevalues{1,i}(startpoint(k,1),combos(q,2)),'r*');
     end
     
 Plot the measurements
 f(q)=plot(random_statevalues{1,i}(samples(1,i),combos(q,1)),random_statevalues{1,i}(samples(1,i),combos(q,2)),'go') ;
     
 end
 xlabel(statenames(1,combos(q,1)))
 ylabel(statenames(1,combos(q,2)))
 title('Simulated Dataset')
 hold off;
 end
 end