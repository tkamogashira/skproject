function fraclengths = setfraclengths(this, fraclengths)
%SETFRACLENGTH   PreSet function for the 'fraclengths' property.

%   Author(s): J. Schickler
%   Copyright 1999-2003 The MathWorks, Inc.

h = getcomponent(this, '-class', 'siggui.labelsandvalues');

if ~isempty(h),
    vals = get(h, 'Values');
    vals = [vals(1); fraclengths];
    set(h, 'Values', vals);
end

% [EOF]
