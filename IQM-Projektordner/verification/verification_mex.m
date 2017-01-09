%function[] = verification_mex(tF)
%% Script for model verification
% Extraction of the results MATLAB-Model

%tF = 0:200;    % the final timepoint of simulation

%simTime = 0:200;    % the final timepoint of simulation
%results_m=model_toettcher2008matlab(tF);
results_m=model_toettcher2008matlab();
y_T = transpose(results_m.y); %y_T = transposed y from results_m (Statevalues) MATLAB-Model
x_T = transpose(results_m.x); %x_T = transposed x from results_m (Time) MATLAB-Model
time_vector = x_T;
% Extraction of the results MEX-model
results_mex = model_toettcher2008mex(time_vector);
y_mex = results_mex.statevalues; % Statevalues IQM-Model
x_mex = results_mex.time;        % Time IQM-Model
y_mext= transpose(results_mex.statevalues); %Adapt matrix range
x_mext= transpose(results_mex.time);        %Adapt matrix range


% Calculate the difference of the outputs between the 2 models
eps = 0.0001;
model_differences_mex = (y_T-y_mex).^2./y_T;
test_mex = model_differences_mex > eps; % y_T = States from Toettcher , y_iqm = States from MEX-Model 


%%
number_wrong_timepoints_mex = sum(test_mex,1);
wrong_states_mex = results_mex.states(number_wrong_timepoints_mex~=0);

plot(x_T,model_differences_mex(:,number_wrong_timepoints_mex~=0))
legend(wrong_states_mex)
figure
timerange = length(x_T)-200:length(x_T);
plot(x_T(timerange),y_T(timerange,number_wrong_timepoints_mex~=0),'.', 'LineWidth', 3)
hold on
plot(x_T(timerange),y_mex(timerange,number_wrong_timepoints_mex~=0),':', 'LineWidth', 3)

legend(wrong_states_mex)
%end

