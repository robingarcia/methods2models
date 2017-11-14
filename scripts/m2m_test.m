%% m2m_test
% Dependencies of this toolbox
[fList,pList] = matlab.codetools.requiredFilesAndProducts('m2m.m');
fList=fList';

% Check integrity of the functions
if 
    disp('Function ok!')
else
    disp('Function broken!')
end