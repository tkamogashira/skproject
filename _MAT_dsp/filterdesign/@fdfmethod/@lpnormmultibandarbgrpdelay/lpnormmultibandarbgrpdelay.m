function this = lpnormmultibandarbgrpdelay
%LPNORMMULTIBANDARBGRPDELAY Construct a LPNORMMULTIBANDARBGRPDELAY object.

%   Copyright 2010 The MathWorks, Inc.

this = fdfmethod.lpnormmultibandarbgrpdelay;
this.DesignAlgorithm = 'IIR Least P-Norm';
this.MaxPoleRadius = 0.999999;

% [EOF]
