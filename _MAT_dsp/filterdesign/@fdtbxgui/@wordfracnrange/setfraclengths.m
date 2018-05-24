function f = setfraclengths(this, fraclengths)
%SETFRACLENGTHS   PreSet function for f 'fraclengths' property.

%   Copyright 1999-2012 The MathWorks, Inc.

f = {};

h = getcomponent(this, '-class', 'siggui.selectorwvalues');

if isempty(h), return; end

for indx = 1:min(this.Maximum, length(fraclengths))
    vals = get(h(indx), 'Values');
    vals{1} = fraclengths{indx};
    set(h(indx), 'Values', vals);
end

% [EOF]
