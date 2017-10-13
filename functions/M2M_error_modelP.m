function M2M_error_modelP(mydata,errordata,statenames)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%% Compare both datasets
%% 3D Plot
% plot3k({mydata(7,:),mydata(11,:),mydata(32,:)})
% hold on
% plot3k({errordata(7,:),errordata(11,:),errordata(32,:)})

% scatter3(mydata(7,1:500),mydata(11,1:500),mydata(32,1:500),'.')
% hold on
% scatter3(errordata(7,1:500),errordata(11,1:500),errordata(32,1:500),'.')
% title(' $$\sigma=0.1$$','Interpreter','latex')
% xlabel(statenames(7))
% ylabel(statenames(11))
% zlabel(statenames(32))

%% scatter 2D
scatter(mydata(5,1:500),mydata(32,1:500))
hold on
scatter(errordata(5,1:500),errordata(32,1:500))
title(' $$\sigma=0.1$$','Interpreter','latex')
xlabel(statenames(5))
ylabel(statenames(32))
grid on

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

%% matlab2tikz
matlab2tikz('error_model.tex','height', '4cm', 'width', '8cm','floatFormat','%.3g' )
end

