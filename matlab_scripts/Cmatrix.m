function[Y,combi] = Cmatrix(i,j,n, errordata) 
%% Create C-Matrix
x = 1:n-1;
C = nchoosek(x,j);
n_perms = size(C,1); % size(C, Dimension=1)
C = [C,n*ones(n_perms,1)]; % Concatenation (add DNA as j+n column with 32)
cmatrix = zeros(size(C,2), n);
for k = 1:i-1
cmatrix(k,C(i,k)) = 1;
end
cmatrix(end,C(i,end)) = 1; %Add the DNA as last row/column

% Outputs
Y = cmatrix*errordata;
combi = C(i,:); %Which measurement combination were choosen?
end