function structure = get_structure(this, structure)
%GET_STRUCTURE   PreGet function for the 'structure' property.

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.


if isempty(structure)
    structure = 'cascadeallpass';
end

% [EOF]
