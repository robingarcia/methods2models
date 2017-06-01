%% Test for NchooseK vs. VchooseK
A = (1:32);

for i = 1:2
tic
C = nchoosek(A,i);
toc
end
disp('===================================================================')
for j = 10
    tic
    CV = VChooseK(A,j);
    toc
    size(CV,1)
end