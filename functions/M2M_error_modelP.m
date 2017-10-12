function M2M_error_modelP(mydata,errordata,statenames)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%% Compare both datasets
%% 3D Plot
% plot3k({mydata(7,:),mydata(11,:),mydata(32,:)})
% hold on
% plot3k({errordata(7,:),errordata(11,:),errordata(32,:)})

scatter3(mydata(7,:),mydata(11,:),mydata(32,:),'.')
hold on
scatter3(errordata(7,:),errordata(11,:),errordata(32,:),'.')
title(' $$\sigma=0.1$$','Interpreter','latex')
xlabel(statenames(7))
ylabel(statenames(11))
zlabel(statenames(32))

% %% scatter 2D
% scatter(mydata(7,:),mydata(32,:),'.')
% hold on
% scatter(errordata(7,:),errordata(32,:),'.')

% %% 3D Plot
% % plot3k({mydata(7,:),mydata(11,:),mydata(32,:)})
% % hold on
% % plot3k({errordata(7,:),errordata(11,:),errordata(32,:)})
% 
% scatter3(mydata(18,:),mydata(26,:),mydata(32,:),'.')
% hold on
% scatter3(errordata(18,:),errordata(26,:),errordata(32,:),'.')
% title(' $$\sigma=0.1$$','Interpreter','latex')
% xlabel(statenames(7))
% ylabel(statenames(11))
% zlabel(statenames(32))
end

