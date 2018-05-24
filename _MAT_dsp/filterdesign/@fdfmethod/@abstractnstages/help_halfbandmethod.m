function help_halfbandmethod(this)
%HELP_HALFBANDMETHOD   

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.

help_str = sprintf('%s\n%s\n%s\n%s\n', ...
    '    HD = DESIGN(..., ''HalfbandDesignMethod'', DESMETH) specifies the design method', ...
    '    to use when halfband filters are used as part of the multistage design.', ...
    '    DESMETHOD must be a string. Valid design methods for the halfband stages are:',...
    '    ''equiripple'', ''ellip'', and ''iirlinphase''.');

disp(help_str);
disp(' ');


% [EOF]
