function co = ploco(n);
% PLOCO - plotcolors in fixed order, cyclic.

ploco = 'brgmk';
co = ploco(1+rem(n-1,length(ploco)));



