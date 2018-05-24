function type = gettype(this, type)
%GETTYPE   PreGet function for the 'type' property.

%   Author(s): J. Schickler
%   Copyright 1999-2003 The MathWorks, Inc.

if ~isempty(this.privType),
    type = this.privType;
end

% [EOF]
