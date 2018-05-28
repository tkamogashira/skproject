function x = deciRound(x,n);
% DECIROUND - round towards given decimal precision
if nargin<2, n = 1; end

if ~isreal(x),
   x = deciround(real(x),n) + i*deciround(imag(x),n);
   return
end
isz = find(x==0);
x(isz) = 1;
ndig = 1 + floor(log10(x));
fac10 = 10.^(n-ndig);
x = round(x.*fac10)./fac10;
x(isz) = 0;
