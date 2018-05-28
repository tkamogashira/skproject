function x = deciCeil(x,n);
% DeciCeil - upward rounding towards given decimal precision
%    DeciCeil(X,N) rounds X upward to the nearest number>=X having 
%    exactly N significant digits.
%
%    See also DECIROUND.

if nargin<2, n = 1; end

isz = find(x==0);
x(isz) = 1;
ndig = 1 + floor(log10(abs(x)));
fac10 = 10.^(n-ndig);

x = ceil(x.*fac10)./fac10;
x(isz) = 0;
