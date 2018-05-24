function loadarithmetic(this, s)
%LOADARITHMETIC   Load the arithmetic information.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

if s.version.number ~= 0
    if s.version.number == 1
        s.Arithmetic = 'fixed';
    end
    abstract_loadarithmetic(this, s);
end

% [EOF]
