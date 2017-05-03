function[Y] = Cmatrix(i,j,n, errordata) 
%% Create C-Matrix
x = 1:n-1;
C = nchoosek(x,j);

n_perms = size(C,1); % size(C, Dimension=1)

C = [C,n*ones(n_perms,1)]; % Concatenation (add DNA as j+n column with 32)
cmatrix = zeros(size(C,2), n);
cmatrix(1,C(i,1))=1;
cmatrix(end,C(i,end))=1;
Y = cmatrix*errordata;
end