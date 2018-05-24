function S = nullstate2(q)
%NULLSTATE2   

%   Author(s): V. Pellissier
%   Copyright 1999-2003 The MathWorks, Inc.

S = nullstate1(q);
S = [S;S];

% [EOF]
