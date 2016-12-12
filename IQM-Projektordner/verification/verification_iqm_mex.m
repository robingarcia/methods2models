function[] = verification_iqm_mex(tF)
%% Script for model verification
% Extraction of the results MATLAB-Model

%simTime = 0:200;    % the final timepoint of simulation

% Extraction of the results IQM-Model
results_iqm = model_toettcher2008iqm(tF);
y_iqm = results_iqm.statevalues; % Statevalues IQM-Model
x_iqm = results_iqm.time;        % Time IQM-Model
y_iqmt= transpose(results_iqm.statevalues); %Adapt matrix range
x_iqmt= transpose(results_iqm.time);        %Adapt matrix range

% Extraction of the results MEX-model
results_mex = model_toettcher2008mex(x_iqmt);
y_mex = results_mex.statevalues; % Statevalues MEx-Model
x_mex = results_mex.time;        % Time MEX-Model
y_mext= transpose(results_mex.statevalues); %Adapt matrix range
x_mext= transpose(results_mex.time);        %Adapt matrix range


% Calculate the difference of the outputs between the 2 models
eps = 0.0001;
model_differences_iqm = (y_iqm-y_mex).^2./y_iqm;
test_iqm = model_differences_iqm > eps; % y_T = States from Toettcher , y_iqm = States from IQM-Model 


number_wrong_timepoints = sum(test_iqm,1);
wrong_states = results_mex.states(number_wrong_timepoints~=0);
%%
plot(x_iqm,model_differences_iqm(:,number_wrong_timepoints~=0))
legend(wrong_states)
figure
timerange = length(x_iqm)-200:length(x_iqm);
plot(x_iqm(timerange),y_iqm(timerange,number_wrong_timepoints~=0),'.')
hold on
plot(x_iqm(timerange),y_mex(timerange,number_wrong_timepoints~=0),'--')

legend(wrong_states)
end


