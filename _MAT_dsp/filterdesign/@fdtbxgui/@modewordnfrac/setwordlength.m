function wordlength = setwordlength(this, wordlength)
%SETWORDLENGTH   PreSet function for the 'wordlength' property.

%   Author(s): J. Schickler
%   Copyright 1999-2003 The MathWorks, Inc.

h = getcomponent(this, '-class', 'siggui.labelsandvalues');

if ~isempty(h),
    vals = get(h, 'Values');
    vals{1} = wordlength;
    set(h, 'Values', vals);
end


% [EOF]
