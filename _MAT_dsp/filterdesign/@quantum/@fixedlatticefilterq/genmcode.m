function h = genmcode(this)
%GENMCODE   Generate MATLAB code.

%   Author(s): J. Schickler
%   Copyright 1999-2009 The MathWorks, Inc.

h = fir_genmcode(this);

if ~this.CoeffAutoScale
    h.add(', ...\n    ''LatticeFracLength'', %d', this.LatticeFracLength);
end

h.add(', ...\n    ''StateWordLength'', %d', this.StateWordLength);
h.add(', ...\n    ''StateFracLength'', %d', this.StateFracLength);

% [EOF]
