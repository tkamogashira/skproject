function decf = setdecimationfactor(this, decf)
%SETDECIMATIONFACTOR   PreSet function for the 'decimationfactor' property.

%   Author(s): J. Schickler
%   Copyright 1999-2003 The MathWorks, Inc.

switch lower(this.Type)
    case 'decimator'
        set(this, 'decimDecimationFactor', decf);
    case 'interpolator'
        return;
    case 'fractional-rate converter'
        set(this, 'srcDecimationFactor', decf);
end

set(this, 'isDesigned', false);

h = this.JavaHandles;
if ~isempty(h),
    awtinvoke(h.decimation, 'setValue', java.lang.Integer(decf));
end

% [EOF]
