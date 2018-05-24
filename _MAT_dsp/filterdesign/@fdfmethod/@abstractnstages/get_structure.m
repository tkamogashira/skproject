function structure = get_structure(this, structure)
%GET_STRUCTURE   PreGet function for the 'structure' property.

%   Author(s): R. Losada
%   Copyright 2006 The MathWorks, Inc.

if isempty(structure),
    if this.rcf < 0,
        structure = 'firdecim';
    else
        structure = 'firinterp';
    end
end

% [EOF]
