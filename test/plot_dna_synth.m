%% Plot DNA Synthesis
yyaxis left
area(DNA(:,1))
yyaxis right
plot(random_statevalues{1,1}(:,12))

%% 3D Plot
% plot3k({mydata(7,:),mydata(11,:),mydata(32,:)})
% hold on
% plot3k({errordata(7,:),errordata(11,:),errordata(32,:)})

scatter3(mydata(7,:),mydata(11,:),mydata(32,:))
hold on
scatter3(errordata(7,:),errordata(9,:),errordata(28,:))
%% 3D subplot
ip = [1,2,3,4,5,6,7,11,12];
C = nchoosek(ip,2);
a = floor(size(C,1)^(1/2));
b = ceil(size(C,1)/a);
sum=0;
figure(1)
while(sum <size(C,1))
for i = 1:size(C,1)
   sum = sum + 1;
   disp(sum)
   hold on
   grid on

   subplot(b,a,sum)
   scatter3(mydata(C(i,1),:),mydata(C(i,2),:),mydata(32,:))
   legend(statenames(C(i,1)))
   hold on
   scatter3(errordata(C(i,1),:),errordata(C(i,2),:),errordata(32,:))
   
end
end
