function h = fixed_genmcode(this)
%FIXED_GENMCODE   Return the fixed point generic mcode.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

h = sigcodegen.mcodebuffer;

h.add(', ...\n    ''Signed'', %s', mat2str(this.Signed));
h.add(', ...\n    ''RoundMode'', ''%s''', this.RoundMode);
h.add(', ...\n    ''OverflowMode'', ''%s''', this.OverflowMode);
% h.add(', ...\n    ''InheritSettings'', %s', mat2str(this.InheritSettings));
h.add(', ...\n    ''InputWordLength'', %d', this.InputWordLength);
h.add(', ...\n    ''InputFracLength'', %d', this.InputFracLength);

% [EOF]
