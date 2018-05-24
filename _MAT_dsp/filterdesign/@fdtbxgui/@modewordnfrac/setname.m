function name = setname(this, name)
%SETNAME   PreSet function for the 'name' property.

%   Author(s): J. Schickler
%   Copyright 1999-2003 The MathWorks, Inc.

h = getcomponent(this, '-class', 'siggui.labelsandvalues');

if ~isempty(h),
    lbls = get(h, 'Labels');
    lbls{1} = sprintf('%s word length:', name);
    set(h, 'Labels', lbls);
end

% [EOF]
