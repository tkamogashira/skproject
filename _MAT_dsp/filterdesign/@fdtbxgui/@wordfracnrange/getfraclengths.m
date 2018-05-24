function f = getfraclengths(this, f)
%GETFRACLENGTHS   PreGet function for the 'fraclengths' property.

%   Author(s): J. Schickler
%   Copyright 1999-2003 The MathWorks, Inc.

h = getcomponent(this, '-class', 'siggui.selectorwvalues');

if isempty(h), return; end

f = {};

for indx = 1:this.Maximum
    f{indx} = get(h(indx), 'Values');
    f{indx} = f{indx}{1};
end

% [EOF]
