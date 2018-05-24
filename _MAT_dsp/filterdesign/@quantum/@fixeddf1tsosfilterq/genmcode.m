function h = genmcode(this)
%GENMCODE   Generate MATLAB code.

%   Author(s): J. Schickler
%   Copyright 1999-2009 The MathWorks, Inc.

h = sos_genmcode(this);

h.add(', ...\n    ''SectionInputAutoScale'', %s', mat2str(this.SectionInputAutoScale));
h.add(', ...\n    ''SectionInputWordLength'', %d', this.SectionInputWordLength);
if ~this.SectionInputAutoScale
    h.add(', ...\n    ''SectionInputFracLength'', %d', this.SectionInputFracLength);
end

h.add(', ...\n    ''SectionOutputAutoScale'', %s', mat2str(this.SectionOutputAutoScale));
h.add(', ...\n    ''SectionOutputWordLength'', %d', this.SectionOutputWordLength);
if ~this.SectionOutputAutoScale
    h.add(', ...\n    ''SectionOutputFracLength'', %d', this.SectionOutputFracLength);
end

h.add(', ...\n    ''StateAutoScale'', %s', mat2str(this.StateAutoScale));
h.add(', ...\n    ''StateWordLength'', %d', this.StateWordLength);
if ~this.StateAutoScale
    h.add(', ...\n    ''NumStateFracLength'', %d', this.NumStateFracLength);
    h.add(', ...\n    ''DenStateFracLength'', %d', this.DenStateFracLength);
end

h.add(', ...\n    ''MultiplicandWordLength'', %d', this.MultiplicandWordLength);
h.add(', ...\n    ''MultiplicandFracLength'', %d', this.MultiplicandFracLength);

% [EOF]
