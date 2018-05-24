function om = set_om(q,om)

%   Author(s): V. Pellissier
%   Copyright 1988-2003 The MathWorks, Inc.

% Set mode of fimath
q.fimath.OverflowMode = om;

om = thisset_om(q,om);
