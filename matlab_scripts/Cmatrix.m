function[Y,combi,cmatrix] = Cmatrix(i,j,n, errordata) 
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
%C = nchoosek(x,j);% MATLAB built-in
C = WChooseK(x,j);% C-Code (MEX) from Jan Simon
% n_perms = size(C,1); % size(C, Dimension=1)/ How many possible combinations?
% C = [C,n*ones(n_perms,1)]; % Concatenation (add DNA as j+n column with 32)
cmatrix = zeros(size(C,2), n); %Row= Measurement output
measure_out = C(i,:); % i = Select the row
for k = 1:length(measure_out)
cmatrix(k,measure_out(k)) = 1;
end
% Outputs
Y = cmatrix*errordata;
combi = C(i,:); %Which measurement combination were choosen?
end