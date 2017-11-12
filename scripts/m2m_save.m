%% m2m save script
clc
save(['w' filename '.mat'], 'm2m_result','-v7.3');
disp(['Workspace succesfully saved as:',filename,'.mat'])
type(['r' filename '.txt']);
m2m_thankyou %Thank you message
cd(workpath);