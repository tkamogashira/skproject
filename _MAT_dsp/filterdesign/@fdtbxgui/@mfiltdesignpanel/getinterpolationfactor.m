function intf = getinterpolationfactor(this, intf)
%GETINTERPOLATIONFACTOR   PreGet function for the 'interpolationfactor' property.

%   Author(s): J. Schickler
%   Copyright 1999-2003 The MathWorks, Inc.

switch lower(this.Type)
    case 'decimator'
        intf = 1;
    case 'interpolator'
        intf = this.interpInterpolationFactor;
    case 'fractional-rate converter'
        intf = this.srcInterpolationFactor;
end

% [EOF]
