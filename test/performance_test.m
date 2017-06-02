%% Perfomance Test
a = (1:31)';
b = 1:size(a,1)+1;
csum = 0;
disp('================================================FOR-LOOP')

for j = 1:2
    tic
    j
    for i = 1:size(VChooseK(a,j),1)
        tic
        i
        csum = csum + i
        toc
    end
    toc
end

%% Allsum
allsum = 1
for j = 1:2
    tic
    j
    for i = 1:size(VChooseK(a,j),1)
        tic
        i
        allsum = allsum * i
        toc
    end
    toc
end

% disp('=================================================Vectorizing')
% tic
% a = (1:31)';
% for j = 1:5
% i(1,j) = size(VChooseK(a,j),1)
% isum = sum(i)
% toc
% end