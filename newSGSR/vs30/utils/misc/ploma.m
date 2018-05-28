function ma = ploma(n);
% PLOMA - plotmarkers in fixed order, cyclic. Single dot excluded.

ploma = {'+' 'o' '*' 'x' 's' 'd' 'v' '^' '>' '<' 'p' 'h'};
ma = ploma{1+rem(n-1,length(ploma))};



