function help_cic(this, type)
%HELP_CIC   

%   Author(s): J. Schickler
%   Copyright 2005 The MathWorks, Inc.

cic_str = sprintf('%s\n%s\n%s', ...
    sprintf('DESIGN   Designs a CIC %s.', type), ...
    sprintf('   HD = DESIGN(D, ''multisection'') designs a CIC %s.  The optimal number', type), ...
    '   of sections will be determined based on the specifications provided.');

disp(cic_str);
disp(' ');

% [EOF]
