function thisloadobj(this, s)
%THISLOADOBJ   

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

iir_thisloadobj(this, s);

set(this, ...
    'MultiplicandWordLength', s.MultiplicandWordLength, ...
    'MultiplicandFracLength', s.MultiplicandFracLength, ...
    'StateWordLength',        s.StateWordLength, ...
    'StateAutoScale',         s.StateAutoScale);

if ~this.StateAutoScale
    set(this, ....
        'NumStateFracLength', s.NumStateFracLength, ...
        'DenStateFracLength', s.DenStateFracLength);
end

% [EOF]
