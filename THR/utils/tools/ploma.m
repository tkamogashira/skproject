function ma = ploma(n);
% PLOMA - plotmarkers in fixed order, cyclic. Single dot excluded.
%   PLOMA(N) returns the Nth plot marker. PLOMA(N+12) == PLOMA(N).
%
%   See also PLOCO.

ploma = {'+' 'o' '*' 'x' 's' 'd' 'v' '^' '>' '<' 'p' 'h'};
ma = ploma{1+rem(n-1,length(ploma))};



