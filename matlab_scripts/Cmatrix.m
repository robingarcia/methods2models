function[C] = Cmatrix(j) 
%% Create C-Matrix
%for j = 1
x = 1:31;
C = nchoosek(x,j);
%end
%MatSize = length(C);
%Cmatri = zeros(MatSize+1,32);
%Cmatri(length(Cmatri),32) = 1;

%for k = 1:MatSize
%    v = C(k,1);
%    w = C(k,2);
%   Cmatri(k,v)=1;
%   Cmatri(k,w)=1;
%end
end