function h = genmcode(this)
%GENMCODE   Generate M-code.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

h = df1_genmcode(this);

h.add(', ...\n    ''StateAutoScale'', %s', mat2str(this.StateAutoScale));
h.add(', ...\n    ''StateWordLength'', %d', this.StateWordLength);
if ~this.StateAutoScale
    h.add(', ...\n    ''StateFracLength'', %d', this.StateFracLength);
end


% [EOF]
