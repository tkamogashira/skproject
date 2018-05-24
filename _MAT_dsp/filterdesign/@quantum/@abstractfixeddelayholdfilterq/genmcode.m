function h = genmcode(this)
%GENMCODE   Return the fixed point generic mcode.

%   Copyright 1999-2011 The MathWorks, Inc.

h = sigcodegen.mcodebuffer;

h.add(',    ''InputWordLength'', %d', this.InputWordLength);
h.add(', ...\n    ''InputFracLength'', %d', this.InputFracLength);

% [EOF]
