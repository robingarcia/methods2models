tic
n=2000;
rndmic = lognrnd_ic(n);
H = cell2mat(rndmic(:));
for i = 1:8
vector = H(:,i);
subplot(4,2,i)
histfit(vector)
end
toc
