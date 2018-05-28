function fb = fracbin(n,m);
% fracbin - binominal coefficient with fractional upper arg

if ~isequal(0,rem(m,1)),
   error('lower arg must be integer');
end

% m<0 fb is zero by definition
if m<0, 
   fb=0; 
   return;
end

fb = prod(n-m+1:n)/prod(1:m);