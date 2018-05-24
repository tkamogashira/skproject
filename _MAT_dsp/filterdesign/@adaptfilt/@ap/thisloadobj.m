function thisloadobj(this, s)
%THISLOADOBJ   Load this object.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

bap_thisloadobj(this, s);

set(this, ...
    'ErrorStates',   s.ErrorStates, ...
    'EpsilonStates', s.EpsilonStates);

% [EOF]
