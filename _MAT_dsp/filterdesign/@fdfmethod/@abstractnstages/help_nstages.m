function help_nstages(this)
%HELP_NSTAGES   

%   Author(s): J. Schickler
%   Copyright 2005 The MathWorks, Inc.

nstages_str = sprintf('%s\n%s\n%s\n%s\n', ...
    '    HD = DESIGN(..., ''NStages'', NSTAGES) specifies the number of stages to', ...
    '    be used in the design with NSTAGES.  NSTAGES must be an integer or the string', ...
    '    ''auto''.  NSTAGES is ''auto'' by default which allows the algorithm to use', ...
    '    the optimal number of stages while minimizing cost. When NSTAGES is specified' , ...
    '    as an integer, the cost is minimized for the number of stages specified.');

disp(nstages_str);
disp(' ');

% [EOF]
