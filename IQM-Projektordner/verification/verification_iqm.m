%% Script for model verification
% Extraction of the results MATLAB-Model

simTime = 0:2000;    % the final timepoint of simulation
results_m=model_toettcher2008matlab(simTime);
y_T = transpose(results_m.y); %y_T = transposed y from results_m (Statevalues) MATLAB-Model
x_T = transpose(results_m.x); %x_T = transposed x from results_m (Time) MATLAB-Model
time_vector = x_T;
% Extraction of the results IQM-Model
results_iqm = model_toettcher2008iqm(time_vector);
y_iqm = results_iqm.statevalues; % Statevalues IQM-Model
x_iqm = results_iqm.time;        % Time IQM-Model
y_iqmt= transpose(results_iqm.statevalues); %Adapt matrix range
x_iqmt= transpose(results_iqm.time);        %Adapt matrix range

% Calculate the difference of the outputs between the 2 models
eps = 0.0001;
model_differences_iqm = (y_T-y_iqm).^2./y_T;
test_iqm = model_differences_iqm > eps; % y_T = States from Toettcher , y_iqm = States from IQM-Model 



number_wrong_timepoints = sum(test_iqm,1);
wrong_states = results_iqm.states(number_wrong_timepoints~=0);
%%
plot(x_T,model_differences_iqm(:,number_wrong_timepoints~=0))
legend(wrong_states)
figure(11)
timerange = length(x_T)-200:length(x_T);
plot(x_T(timerange),y_T(timerange,number_wrong_timepoints~=0),'.')
hold on
plot(x_T(timerange),y_iqm(timerange,number_wrong_timepoints~=0),'--')

legend(wrong_states)



