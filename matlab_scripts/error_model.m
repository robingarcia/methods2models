%% Error model for protein quantification
function [errordata] = error_model(mydata,sig)
%epsilon = lognpdf(mydata,0,sig);
epsilon = exp(randn(size(mydata))*sig);
errordata =mydata .* epsilon;
end
