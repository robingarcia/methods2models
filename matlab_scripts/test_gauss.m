tic
n=1000;
rndmic = lognrnd_ic(n);
H = cell2mat(rndmic(:));
for i = 1:31
vector = H(:,i);
subplot(8,4,i)
histfit(vector)
end
toc
