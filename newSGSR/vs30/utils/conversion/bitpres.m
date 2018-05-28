function BP = bitpres(x,maxNbit,minNbit);

if nargin<2, maxNbit = 32; end;
if nargin<3, minNbit = 1; end;

x = x(:);
N = length(x);
if N>1,
   BP = zeros(N,maxNbit-minNbit+1);
   for ii=1:N,
      BP(ii,:) = bitpres(x(ii),maxNbit,minNbit);
   end
   return;
end

BP = bitget(x,minNbit:maxNbit);