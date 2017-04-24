%% Error model for protein quantification
function [y_hat] = error_model(mydata)
number_of_cells = length(mydata);
y_hat = zeros(32,800);
for i = 1:number_of_cells
    onedata = mydata(:,i);
mydata_not_zero = onedata(onedata ~=0);
sigma = 1;
M = onedata;
V = sigma .* onedata;
MU = log(M.^2 / sqrt(V+M.^2));
SIGMA = sqrt(log(V./M.^2 + 1));
[M,V] = lognstat(MU,SIGMA);
L = length(onedata);
for j = 1:L %ICdefault = 0;        
        mydata_not_zero = lognrnd(0,SIGMA);
        error_rndm = mydata_not_zero;
end
        y_hat(:,i) = error_rndm;
end
