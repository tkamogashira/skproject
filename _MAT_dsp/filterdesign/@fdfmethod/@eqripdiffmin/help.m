function help(this)
%HELP   

%   Author(s): J. Schickler
%   Copyright 2005 The MathWorks, Inc.

help_equiripple(this);
help_densityfactor(this);
disp(sprintf('%s\n%s', ...
    '    Notice that the resulting filter will always be of type IV (odd order).',...
    '    The passband will cover the entire frequency range.'));
disp(' ');

help_examples(this);

% [EOF]
