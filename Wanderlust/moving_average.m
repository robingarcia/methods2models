function ywant = moving_average(x,y,xwant,binsize)

[~,nx] = size(x);
[d,n] = size(y);
xi = xwant(:);
[~,N] = size(xwant);

if nx ~= n
	error('length in the second dimension must be same for x and y')
end

% moving horizont
inbin = (bsxfun(@ge,x,-binsize/2+xi) & bsxfun(@lt,x,binsize/2+xi));

% preallocate output
ywant = zeros(d,N);
for i=1:N
	ywant(:,i) = sum(y(:,inbin(i,:)),2) ./ sum(inbin(i,:));
end





