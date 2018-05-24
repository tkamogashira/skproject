function thisloadobj(this, s)
%THISLOADOBJ   Load the object.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

out_thisloadobj(this, s);

if ~this.CoeffAutoScale
    set(this, 'CoeffFracLength', s.CoeffFracLength);
end

% [EOF]
