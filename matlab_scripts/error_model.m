%% Error model for protein quantification
function [errordata] = error_model(mydata,sig)
epsilon = exp(rand(size(mydata))*sig);
errordata = mydata .* epsilon;
end