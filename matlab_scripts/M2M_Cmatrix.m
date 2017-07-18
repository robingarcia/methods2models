function[Y,combi,cmatrix] = M2M_Cmatrix(i,j,n, errordata) 
%% Create C-Matrix
%This function selects your measurement.
%
% [SYNTAX]
% [Y,combi,cmatrix] = Cmatrix(i,j,n, errordata)
%
%  [INPUT]
%  i:             number: Number of combinations
%  j:             number: Number of measurement outputs
%  n:             number: Number of cells
%  errordata:     number: Dataset
%  
%  [OUTPUT]
%  Y:             Number: Measured dataset
%  combi:         String: Measurement combination
%  cmatrix:       Number: ?

x = 1:n-1; %Substract the DNA part
C = WChooseK(x,j);% C-Code (MEX) from Jan Simon
cmatrix = zeros(size(C,2), n); %Row= Measurement output
measure_out = C(i,:); % i = Select the row
for k = 1:length(measure_out)
cmatrix(k,measure_out(k)) = 1;
end
% Outputs
Y = cmatrix*errordata;
combi = C(i,:); %Which measurement combination were choosen?
end