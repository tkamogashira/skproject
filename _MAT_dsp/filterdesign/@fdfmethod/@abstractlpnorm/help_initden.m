function help_initden(~)
%HELP_INITDEN  

%   Copyright 2010 The MathWorks, Inc.

init_str = sprintf('%s\n%s\n%s\n%s', ...
    '    HD = DESIGN(..., ''InitNum'', INITNUM, ''InitDen'', INITDEN) specifies an', ...
    '    initial estimate of the filter numerator and denominator coefficient in', ...
    '    vectors INITNUM and INITDEN respectively. This may be useful for difficult', ...
    '    optimization problems. INITNUM and INITDEN are empty by default.');
disp(init_str);
disp(' ');

% [EOF]
