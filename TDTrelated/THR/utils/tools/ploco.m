function co = ploco(n);
% PLOCO - plot colors in fixed order, cyclic.
%    PLOCO(N) returns the Nth plot color. PLOCO(N+5)=PLOCO(N).
%
%    See also PLOMA.

ploco = 'brgmk';
co = ploco(1+rem(n-1,length(ploco)));



