function help_zerophase(this)
%HELP_ZEROPHASE 

%   Copyright 2009 The MathWorks, Inc.

zerophase_str = sprintf('%s\n%s\n%s', ...
    '    HD = DESIGN(..., ''ZeroPhase'', ZPHASE) designs a filter with a', ...
    '    nonnegative zero-phase response when ZPHASE is TRUE.  ZPHASE is ', ...
    '    FALSE by default.');

disp(zerophase_str);
disp(' ');

% [EOF]

