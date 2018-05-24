function out = getextraobjparam(this,hspecs)
%GETEXTRAOBJPARAM Get the extra parameter for the creation of the object.

%   Copyright 2007 The MathWorks, Inc.

out = {hspecs.privInterpolationFactor, hspecs.privDecimationFactor};

% [EOF]