function[Y,combi,cmatrix] = Cmatrix(i,j,n, errordata) 
%% Create C-Matrix
x = 1:n;%-1; %Substract the DNA part
C = nchoosek(x,j);
n_perms = size(C,1); % size(C, Dimension=1)/ How many possible combinations?
C = [C,n*ones(n_perms,1)]; % Concatenation (add DNA as j+n column with 32)
cmatrix = zeros(size(C,2), n); %Row= Measurement output
measure_out = C(i,:); % i = Select the row
for k = 1:length(measure_out)
cmatrix(k,measure_out(k)) = 1;
end
% Outputs
Y = cmatrix*errordata;
combi = C(i,:); %Which measurement combination were choosen?
end