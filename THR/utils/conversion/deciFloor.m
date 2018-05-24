function x = deciFloor(x,n);
% DECIFLOOR - truncate towards given decimal precision
%    DECIFLOOR(X,N) truncates X toward the nearest number having 
%    exactly N significant digits.
%
%    See also DECIROUND.

if nargin<2, n = 1; end

isz = find(x==0);
x(isz) = 1;
ndig = 1 + floor(log10(abs(x)));
fac10 = 10.^(n-ndig);

x = floor(x.*fac10)./fac10;
x(isz) = 0;
