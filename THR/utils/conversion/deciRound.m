function x = deciRound(x,n);
% DECIROUND - round towards given decimal precision
%    DECIROUND(X,N) rounds X toward the nearest number having 
%    exactly N significant digits.
%
%    Examples
%       DECIROUND(pi, 1) returns 3
%       DECIROUND(100*pi, 1) returns 300
%       DECIROUND(pi, 3) returns 3.14
%       DECIROUND(100*pi, 3) returns 314
%       DECIROUND(pi/10, 3) returns 0.314
%       DECIROUND(0.99, 2) returns 0.99
%       DECIROUND(0.999, 2) returns 1
%
%    See also ROUND.

if nargin<2, n = 1; end

isz = find(x==0);
x(isz) = 1;
ndig = 1 + floor(log10(abs(x)));
fac10 = 10.^(n-ndig);

x = round(x.*fac10)./fac10;
x(isz) = 0;
