function Q = rel_difference(this)
%REL_DIFFERENCE   

%   Author(s): R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.


% Determine relative difference between extremals 
errext = this.errext(2:end);
n = norm(errext,inf);
Q = (n-min(abs(errext)))/n;

% [EOF]
