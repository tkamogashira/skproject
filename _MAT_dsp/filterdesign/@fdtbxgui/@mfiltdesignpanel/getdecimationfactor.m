function decf = getdecimationfactor(this, decf)
%GETDECIMATIONFACTOR   PreGet function for the 'decimationfactor' property.

%   Author(s): J. Schickler
%   Copyright 1999-2003 The MathWorks, Inc.

switch lower(this.Type)
    case 'decimator'
        decf = this.decimDecimationFactor;
    case 'interpolator'
        decf = 1;
    case 'fractional-rate converter'
        decf = this.srcDecimationFactor;
end

% [EOF]
