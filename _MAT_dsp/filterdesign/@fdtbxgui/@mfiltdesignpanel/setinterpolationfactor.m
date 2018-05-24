function intf = setinterpolationfactor(this, intf)
%SETINTERPOLATIONFACTOR   PreSet function for the 'interpolationfactor' property.

%   Author(s): J. Schickler
%   Copyright 1999-2003 The MathWorks, Inc.

switch lower(this.Type)
    case 'interpolator'
        set(this, 'interpInterpolationFactor', intf);
    case 'decimator'
        return;
    case 'fractional-rate converter'
        set(this, 'srcInterpolationFactor', intf);
end

set(this, 'isDesigned', false);

h = this.JavaHandles;
if ~isempty(h),
    awtinvoke(h.interpolation, 'setValue', java.lang.Integer(intf));
end

% [EOF]
