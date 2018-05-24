function h = genmcode(this)
%GENMCODE   Generate the mcode.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

h = iir_genmcode(this);

h.add(', ...\n    ''StateAutoScale'', %s', mat2str(this.StateAutoScale));
h.add(', ...\n    ''StateWordLength'', %d', this.StateWordLength);
if ~this.StateAutoScale
    h.add(', ...\n    ''NumStateFracLength'', %d', this.NumStateFracLength);
    h.add(', ...\n    ''DenStateFracLength'', %d', this.DenStateFracLength);
end

h.add(', ...\n    ''MultiplicandWordLength'', %d', this.MultiplicandWordLength);
h.add(', ...\n    ''MultiplicandFracLength'', %d', this.MultiplicandFracLength);

% [EOF]
