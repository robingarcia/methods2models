function [results_mex]=mexexist(tF,ic)
% Windows
if ispc
    if exist('/model_toettcher2008MEX.mexmaci64', 'file')
        disp('Succes! MEX file found!');
        results_mex = model_toettcher2008MEX(tF,ic);
    else
        disp('No MEX file found!');
        disp('New MEX file will be generated...');
        model_toettcher2008mex(tF,ic)
    end
% macOS    
elseif ismac
    if exist('/model_toettcher2008MEX.mexmaci64', 'file')
        disp('Succes! MEX file found!');
        results_mex = model_toettcher2008MEX(tF,ic);
    else
        disp('No MEX file found!');
        disp('New MEX file will be generated...');
        model_toettcher2008mex(tF,ic)
    end
% Unix    
elseif isunix
     if exist('/model_toettcher2008MEX.mexa64', 'file')
         disp('Succes! MEX file found!');
        results_mex = model_toettcher2008MEX(tF,ic);
     else
        disp('No MEX file found!');
        disp('New MEX file will be generated...');
        model_toettcher2008mex(tF,ic)
     end
else 
    disp('Platform not supported')
    
end
end




