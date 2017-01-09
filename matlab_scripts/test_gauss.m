tic
n=1000;
rndmic = lognrnd_ic(n);
H = cell2mat(rndmic(:));
for i = 1:31
vector = H(:,i);
%a=floor(sqrt(i));
%b=ceil(i/a);

subplot(4,8,i)
histogram(vector)
end
toc
