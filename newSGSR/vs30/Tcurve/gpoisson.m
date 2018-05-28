function x= gpoisson(M, SZ);
% GPOISSON - approximate poisson generator
if nargin<2, SZ = [1 1]; end
if prod(size(M))~=1,
   error('Mean must be single scalar.');
end
if length(SZ)==1,
   SZ = [SZ 1];
end

if M>20, % gaussian is good enough
   x = round(M+sqrt(M)*randn(SZ));
   x(find(x<0)) = round(2*M);
elseif M>0, % run geiger counter
   CH = floor(5*M+10);
   x = sum(rand([CH SZ])<M/CH);
   x = reshape(x,SZ);
elseif M==0,
   x = zeros(SZ);
else,
   error('Illegal Mean value.')
end
