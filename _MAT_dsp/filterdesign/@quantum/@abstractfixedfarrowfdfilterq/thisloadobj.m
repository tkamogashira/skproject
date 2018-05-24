function this = thisloadobj(this, s)
%THISLOADOBJ   Load this object.

%   Author(s): V. Pellissier
%   Copyright 2006 The MathWorks, Inc.

set(this, ...
    'MultiplicandWordLength'      , s.MultiplicandWordLength, ...
    'MultiplicandFracLength'   , s.MultiplicandFracLength, ...
    'FDProdWordLength', s.FDProdWordLength, ...
    'FDProdFracLength', s.FDProdFracLength);


% [EOF]
