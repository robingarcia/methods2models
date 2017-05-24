function [errordata] = error_model(mydata,sig)
%Error model for protein quantification
%This function introduce noise into our dataset.
% 
% [SYNTAX]
% [errordata] = error_model(mydata,sig)
% 
% [INPUT]
% mydata:         number: Your dataset
% sig:            number: Sigma
% 
% [OUTPUT]
% errordata:      number: Dataset with noise

epsilon = exp(randn(size(mydata))*sig);
errordata =mydata .* epsilon;
end
