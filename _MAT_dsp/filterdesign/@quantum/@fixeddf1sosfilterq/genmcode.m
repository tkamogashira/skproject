function h = genmcode(this)
%GENMCODE   Generate MATLAB code.

%   Author(s): J. Schickler
%   Copyright 1999-2009 The MathWorks, Inc.

h = sos_genmcode(this);

h.add(', ...\n    ''NumStateWordLength'', %d', this.NumStateWordLength);
h.add(', ...\n    ''NumStateFracLength'', %d', this.NumStateFracLength);

h.add(', ...\n    ''DenStateWordLength'', %d', this.DenStateWordLength);
h.add(', ...\n    ''DenStateFracLength'', %d', this.DenStateFracLength);

% [EOF]
