function h = out_genmcode(this)
%OUT_GENMCODE   Generate MATLAB code.

%   Author(s): J. Schickler
%   Copyright 1999-2009 The MathWorks, Inc.

h = fixed_genmcode(this);

h.add(', ...\n    ''OutputMode'', ''%s''', this.OutputMode);
h.add(', ...\n    ''OutputWordLength'', %d', this.OutputWordLength);

if strcmpi(this.OutputMode, 'specifyprecision')
    h.add(', ...\n    ''OutputFracLength'', %d', this.OutputFracLength);
end

% [EOF]
