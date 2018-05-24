function help(this)
%HELP   

%   Author(s): J. Schickler
%   Copyright 2005 The MathWorks, Inc.

help_multistage(this);
help_nstages(this);

halfband_str = sprintf('%s\n%s', ...
    '    HD = DESIGN(..., ''UseHalfbands'', HB) uses halfband filters whenever possibe if', ...
    '    HB is TRUE.  HB is FALSE by default.');

disp(halfband_str);
disp(' ');
help_halfbandmethod(this)
help_examples(this);

% [EOF]
