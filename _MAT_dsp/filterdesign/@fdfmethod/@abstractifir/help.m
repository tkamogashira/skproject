function help(this)
%HELP   

%   Author(s): J. Schickler
%   Copyright 2005 The MathWorks, Inc.

help_header(this, 'ifir', 'Interpolated FIR', '');

ufac_str = sprintf('%s\n%s\n%s\n%s', ...
    '    HD = DESIGN(..., ''UpsamplingFactor'', UFACTOR) forces the algorithm to', ...
    '    use UFACTOR as the upsampling factor.  UFACTOR is the string ''auto'' by', ...
    '    default which allows the algorithm to use the upsampling factor which will', ...
    '    result in the lowest filter cost.');

jointopt_str =  sprintf('%s\n%s\n%s\n%s', ...
    '    HD = DESIGN(..., ''JointOptimization'', BF) when BF is TRUE jointly optimizes', ...
    '    the two filters when designing. This can provide significant savings in the', ...
    '    length of the filters (number of multipliers). However, this can take a long', ...
    '    time in some cases. By default, BF is FALSE.');

disp(ufac_str);
disp(' ');

disp(jointopt_str);
disp(' ');

% [EOF]
