%
%    Estimate fr from fpeak 
%    Toshio IRINO
%    10 June 98
%
%  function [fr, ERBw] = Fpeak2Fr(n,b,c,fpeak)
%    INPUT:  n,b,c : gammachirp param.
%            fpeak : peak freq.
%    OUTPUT: fr    : fr
%            ERBw  : ERBw(fr)
%
function [fr, ERBw] = Fpeak2Fr(n,b,c,fpeak)

if nargin < 4; help Fpeak2Fr; end;

n = n(:);
b = b(:);
c = c(:);
fpeak = fpeak(:);

%    fpeak = fr + c*b*ERBw(fr)/n 
%    ERBw(fr) = 24.7*(4.37*fr/1000 + 1) = k1*fr + k2  % M&G 1990

k1 = 24.7*4.37/1000;
k2 = 24.7;

fr = (fpeak - c.*b./n * k2)./(1 + c.*b./n * k1);
ERBw = k1*fr + k2;


