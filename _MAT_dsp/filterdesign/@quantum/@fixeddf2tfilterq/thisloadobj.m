function thisloadobj(this, s)
%THISLOADOBJ   

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

df1_thisloadobj(this, s)

set(this, ...
    'StateWordLength', s.StateWordLength, ...
    'StateAutoScale',  s.StateAutoScale);

if ~this.StateAutoScale
    set(this, 'StateFracLength', s.StateFracLength);
end

% [EOF]
