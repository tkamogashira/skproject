function help(this)
%HELP   

%   Author(s): J. Schickler
%   Copyright 2005 The MathWorks, Inc.

help_equiripple(this);
help_densityfactor(this);
disp(sprintf('%s\n%s\n%s', ...
    '    Notice that the resulting filter will be of type III (even order) except when', ...
    '    the passband frequency is set to 1. In this case the stopband caracteristics', ...
    '    are ignored.'));
disp(' ');

help_examples(this);

% [EOF]
