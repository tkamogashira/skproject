function wordlength = getwordlength(this, wordlength)
%GETWORDLENGTH   PreGet function for the 'wordlength' property.

%   Author(s): J. Schickler
%   Copyright 1999-2003 The MathWorks, Inc.

h = getcomponent(this, '-class', 'siggui.labelsandvalues');

if ~isempty(h),
    vals = get(h, 'Values');
    if isempty(vals),
        wordlength = '';
    else
        wordlength = vals{1};
    end
end


% [EOF]
