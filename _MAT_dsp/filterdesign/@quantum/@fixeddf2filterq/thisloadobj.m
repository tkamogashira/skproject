function thisloadobj(this, s)
%THISLOADOBJ   

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

iir_thisloadobj(this, s);

set(this, ...
    'StateWordLength', s.StateWordLength, ...
    'StateFracLength', s.StateFracLength);

% [EOF]
