%% Error model for protein quantification
function [errordata] = error_model(mydata,sig)
%sig = 0.2;
epsilon = exp(rand(size(mydata))*sig);
errordata = mydata .* epsilon;
end
