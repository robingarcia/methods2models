%% m2m save script
save(['w' filename '.mat'], 'm2m_result','-v7.3');
disp(['Workspace succesfully saved as:',filename,'.mat'])
cd(workpath);