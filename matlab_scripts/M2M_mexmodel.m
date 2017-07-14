function  M2M_mexmodel(input)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%Check if mex file exist
mexmodelname = input.mexmodelname;
[~,filename,extension] = fileparts(mexmodelname);

if strcmp(extension, '.mexa64')
    
else 
    model = IQMmodel(mexmodelname); %Still error
    cd('/home/robin/methods2models/models')
    IQMmakeMEXmodel(model,filename);
end

end

