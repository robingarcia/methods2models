%% Script for model verification
% Extraction of the results MATLAB-Model

simTime = 0:200;    % the final timepoint of simulation
results_m=model_toettcher2008matlab(simTime);
y_T = transpose(results_m.y); %y_T = transposed y from results_m (Statevalues) MATLAB-Model
x_T = transpose(results_m.x); %x_T = transposed x from results_m (Time) MATLAB-Model

% Extraction of the results IQM-Model
results_iqm = model_toettcher2008iqm(x_T);
y_iqm = results_iqm.statevalues; % Statevalues IQM-Model
x_iqm = results_iqm.time;        % Time IQM-Model
y_iqmt= transpose(results_iqm.statevalues); %Adapt matrix range
x_iqmt= transpose(results_iqm.time);        %Adapt matrix range


% Calculate the difference of the outputs between the 2 models
eps = 0.0001;
model_differences = (y_T-y_iqm).^2./y_T;
test = model_differences > eps; % y_T = States from Toettcher , y_iqm = States from IQM-Model 
%Plot the test as a checkered pattern
figure(5)
[r,c] = size(test);                          % Get the matrix size
imagesc((1:c)+0.5,(1:r)+0.5,test);           % Plot the image
colormap(gray);                              % Use a gray colormap
axis equal                                   % Make axes grid sizes equal
set(gca,'XTick',1:(c+1),'YTick',1:(r+1),...  % Change some axes properties
        'XLim',[1 c+1],'YLim',[1 r+1],...
        'GridLineStyle','-','XGrid','on','YGrid','on');

number_wrong_timepoints = sum(test,1);
wrong_states = results_iqm.states(number_wrong_timepoints~=0);
%%
plot(x_T,model_differences(:,number_wrong_timepoints~=0))
legend(wrong_states)
figure
timerange = length(x_T)-200:length(x_T);
plot(x_T(timerange),y_T(timerange,number_wrong_timepoints~=0),'.')
hold on
plot(x_T(timerange),y_iqm(timerange,number_wrong_timepoints~=0),'--')

legend(wrong_states)




