function h = genmcode(this)
%GENMCODE   Generate the MATLAB code.

%   Author(s): J. Schickler
%   Copyright 1999-2009 The MathWorks, Inc.

h = fir_genmcode(this);

if ~this.CoeffAutoScale
    h.add(', ...\n    ''NumFracLength'', %d', this.NumFracLength);
end

h.add(', ...\n    ''StateAutoScale'', %s', mat2str(this.StateAutoScale));
h.add(', ...\n    ''StateWordLength'', %d', this.StateWordLength);
if ~this.StateAutoScale
    h.add(', ...\n    ''StateFracLength'', %d', this.StateFracLength);
end

% [EOF]
