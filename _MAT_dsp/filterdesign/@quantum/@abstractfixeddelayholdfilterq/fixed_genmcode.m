function h = fixed_genmcode(this)
%FIXED_GENMCODE   Return the fixed point generic mcode.

%   Author(s): J. Schickler
%   Copyright 1999-2005 The MathWorks, Inc.

h = sigcodegen.mcodebuffer;

h.add(', ...\n    ''InputWordLength'', %d', this.InputWordLength);
h.add(', ...\n    ''InputFracLength'', %d', this.InputFracLength);

% [EOF]
