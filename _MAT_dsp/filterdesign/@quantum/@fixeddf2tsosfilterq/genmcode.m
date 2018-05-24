function h = genmcode(this)
%GENMCODE   Generate MATLAB code.

%   Author(s): J. Schickler
%   Copyright 1999-2009 The MathWorks, Inc.

h = sos_genmcode(this);

h.add(', ...\n    ''SectionInputWordLength'', %d', this.SectionInputWordLength);
h.add(', ...\n    ''SectionInputFracLength'', %d', this.SectionInputFracLength);

h.add(', ...\n    ''SectionOutputWordLength'', %d', this.SectionOutputWordLength);
h.add(', ...\n    ''SectionOutputFracLength'', %d', this.SectionOutputFracLength);

h.add(', ...\n    ''StateAutoScale'', %s', mat2str(this.StateAutoScale));
h.add(', ...\n    ''StateWordLength'', %d', this.StateWordLength);
if ~this.StateAutoScale
    h.add(', ...\n    ''StateFracLength'', %d', this.StateFracLength);
end

% [EOF]
