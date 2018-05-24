function this = lpnormsbarbgrpdelay
%LPNORMSBARBGRPDELAY Construct a LPNORMSBARBGRPDELAY object.

%   Copyright 2010 The MathWorks, Inc.

this = fdfmethod.lpnormsbarbgrpdelay;
this.DesignAlgorithm = 'IIR Least P-Norm';
this.MaxpoleRadius = 0.999999;

% [EOF]
