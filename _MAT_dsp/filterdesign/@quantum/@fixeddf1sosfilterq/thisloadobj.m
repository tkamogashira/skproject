function thisloadobj(this, s)
%THISLOADOBJ   

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

sos_thisloadobj(this, s);

set(this, 'NumStateWordLength', s.NumStateWordLength, ...
    'NumStateFracLength', s.NumStateFracLength, ...
    'DenStateWordLength', s.DenStateWordLength, ...
    'DenStateFracLength', s.DenStateFracLength);

% [EOF]
