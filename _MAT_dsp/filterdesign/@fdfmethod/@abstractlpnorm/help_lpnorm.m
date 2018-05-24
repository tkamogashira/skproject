function help_lpnorm(this)
%HELP_LPNORM   

%   Author(s): J. Schickler
%   Copyright 2005-2010 The MathWorks, Inc.

help_header(this, 'iirlpnorm', 'Least p''th norm', 'IIR');

norm_str = sprintf('%s\n%s\n%s', ...
    '    HD = DESIGN(..., ''Norm'', P) specifies the norm to be used for the', ...
    '    optimization. The default norm is 128 which essentially yields the', ...
    '    L-infinity, or Chebyshev, norm.');
disp(norm_str);
disp(' ');

help_densityfactor(this, 20);

help_maxpole(this);

initnorm_str = sprintf('%s\n%s\n%s', ...
    '    H = IIRLPNORM(..., ''InitNorm'', INITNORM) specifies the initial norm used', ...
    '    by the algorithm.  The default initial norm is 2. The use of a small', ...
    '    initial norm improves the convergence of designs.');
disp(initnorm_str);
disp(' ');

help_initden(this);

help_sosscale(this);

% [EOF]
