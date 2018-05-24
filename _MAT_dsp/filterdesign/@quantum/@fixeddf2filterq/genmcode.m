function h = genmcode(this)
%GENMCODE   Generate the mcode.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

h = iir_genmcode(this);

h.add(', ...\n    ''StateWordLength'', %d', this.StateWordLength);
h.add(', ...\n    ''StateFracLength'', %d', this.StateFracLength);

% [EOF]
