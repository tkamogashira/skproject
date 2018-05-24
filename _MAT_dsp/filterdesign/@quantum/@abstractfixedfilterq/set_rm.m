function rm = set_rm(q,rm)

%   Author(s): R. Losada
%   Copyright 1988-2003 The MathWorks, Inc.

% Set mode of fimath
q.fimath.RoundMode = rm;

rm = thisset_rm(q,rm);
