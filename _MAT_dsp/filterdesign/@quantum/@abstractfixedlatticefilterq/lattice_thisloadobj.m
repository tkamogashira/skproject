function lattice_thisloadobj(this, s)
%LATTICE_THISLOADOBJ   Load this object.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

nonscalar_thisloadobj(this, s);

if ~this.CoeffAutoScale
    set(this, 'LatticeFracLength', s.LatticeFracLength);
end

set(this, 'StateWordLength', s.StateWordLength, ...
    'StateFracLength', s.StateFracLength);

% [EOF]
