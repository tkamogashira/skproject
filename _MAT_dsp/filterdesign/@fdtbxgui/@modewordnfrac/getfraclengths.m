function fraclengths = getfraclengths(this, fraclengths)
%GETFRACLENGTHS   PreGet function for the 'fraclengths' property.

%   Author(s): J. Schickler
%   Copyright 1999-2003 The MathWorks, Inc.

h = getcomponent(this, '-class', 'siggui.labelsandvalues');

if ~isempty(h),
    vals = get(h, 'Values');
    if isempty(vals),
        fraclengths = {};
    else
        fraclengths = vals(2:end);
    end
end

% [EOF]
