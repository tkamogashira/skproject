function Hd = createobj(this,coeffcell)
%CREATEOBJ   

%   Copyright 2007 The MathWorks, Inc.

struct = get(this, 'FilterStructure');
Hd = feval(['mfilt.' struct], coeffcell{1}{1}, coeffcell{1}{2}, coeffcell{2});

% [EOF]

